import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    (node as? XElement)?.xPath ?? node?.parent?.xPath
}

fileprivate let elementInfoAttachmentName = "element-info"

public extension XElement {
    
    /// Use this extension to `XElement` to set the attachments `xpath` and the element description to be used for error messages.
    /// If `useForElementInfo`, the XPath for any if its descendants will stop there.
    func setElementInfo(xPath: String? = nil, from other: XElement? = nil) {
        self.attached["xpath"] = xPath ?? self.attached["xpath"] ?? (other ?? self).xPathConsideringAttached
        self.attached["element"] = self.attached["element"] ?? "\(other ?? self)"
    }
    
    func useForElementInfo() {
        self.attached[elementInfoAttachmentName] = true
    }
    
    func copyElementInfo(from other: XElement) {
        self.attached["xpath"] = other.attached["xpath"]
        self.attached["element"] = other.attached["element"]
        self.attached[elementInfoAttachmentName] = other.attached[elementInfoAttachmentName]
    }
    
}

public extension XElement {
    
    var xPathConsideringAttached: String {
        if let ancestorWithSavedXPath = self.ancestorsIncludingSelf.filter({ ($0.attached["xpath"] as? String != nil) }).first, let relativePath = self.xPath(relativeTo: ancestorWithSavedXPath) {
            return "\(ancestorWithSavedXPath.attached["xpath"] as? String ?? "?")\(relativePath == "." ? "" : "/\(relativePath)")"
        }
        else {
            return self.xPath
        }
    }
}

public extension XNode {
    
    /// The information about the position fo a node first searches for the attachment of name `xpath` for the XPath.
    var positionInfo: String? {
        guard let element = self.ancestors.reversed().filter({ $0.attached[elementInfoAttachmentName] as? Bool == true }).first ?? self as? XElement ?? self.parent else { return nil }
        return "\(element.xPathConsideringAttached) (\(element.attached["element"] ?? "\(element)"))"
    }
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: [String]) {
        log(message, itemPositionInfo: node?.positionInfo, withArguments: arguments)
    }
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) {
        log(message, node: node, arguments)
    }
    
    func log(setPIWithTarget piTarget: String?, _ message: Message, node: XNode?, _ arguments: [String]) {
        let info = logAndUseInfo(message, itemPositionInfo: node?.positionInfo, withArguments: arguments)
        if let piTarget {
            (node as? XElement)?.addFirst { XProcessingInstruction(target: piTarget, data: "'\(info)'") }
        }
    }
    
    func log(setPIWithTarget piTarget: String?, _ message: Message, node: XNode?, _ arguments: String...) {
        log(setPIWithTarget: piTarget, message, node: node, arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: [String]) -> String {
        logAndUseInfo(message, itemPositionInfo: node?.positionInfo, withArguments: arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: String...) -> String {
        logAndUseInfo(message, node: node, arguments)
    }
    
}
