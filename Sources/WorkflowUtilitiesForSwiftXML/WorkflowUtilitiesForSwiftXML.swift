import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    (node as? XElement)?.xPath ?? node?.parent?.xPath
}

public extension XElement {
    
    /// Use this extension to `XElement` to set the attachments `xpath` to be used for error messages.
    /// If `usingAsXPathBarrier`, the XPath for any if its descendants will stop there.
    func setElementInfo(xPath: String? = nil, from other: XElement? = nil) {
        self.attached["xpath"] = xPath ?? (other ?? self).xPathConsideringAttached
    }
    
    func useAsXPathBarrier() {
        self.attached["xpath-barrier"] = true
    }
    
    func copyElementInfo(from other: XElement) {
        self.attached["xpath"] = other.attached["xpath"]
        self.attached["xpath-barrier"] = other.attached["xpath-barrier"]
    }
    
}

public extension XNode {
    
    var xPathConsideringAttached: String? {
        guard let element = self as? XElement ?? self.parent else { return nil }
        if let ancestorWithSavedXPath = self.ancestorsIncludingSelf.filter({ ($0.attached["xpath"] as? String != nil) }).first, let relativePath = element.xPath(relativeTo: ancestorWithSavedXPath) {
            return "\(ancestorWithSavedXPath.attached["xpath"] as? String ?? "?")\(relativePath == "." ? "" : "/\(relativePath)")"
        }
        else {
            return element.xPath
        }
    }
    
    /// The information about the position fo a node first searches for the attachment of name `xpath` for the XPath.
    var positionInfo: String? {
        guard let xPath = (self.ancestors.reversed().filter{ $0.attached["xpath-barrier"] as? Bool == true }.first ?? self).xPathConsideringAttached else { return nil }
        if xPath.hasPrefix("/") {
            return "\(self) (\(xPath))"
        } else {
            return "\(self)"
        }
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
