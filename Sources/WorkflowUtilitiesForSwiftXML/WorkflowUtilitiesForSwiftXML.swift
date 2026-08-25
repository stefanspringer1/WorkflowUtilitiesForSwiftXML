import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    (node as? XElement)?.xPath ?? node?.parent?.xPath
}

public extension XElement {
    
    /// Use this extension to `XElement` to set the attachments `xpath` and `element` to be used for error messages.
    /// If `forWholeSubtree: true` is set, the same is done for all descendants.
    func setElementInfo(from other: XElement? = nil, forWholeSubtree: Bool = false) {
        self.attached["xpath"] = self.xPathConsideringAttached
        if self.attached["element"] == nil { self.attached["element"] = (other ?? self).description }
        if forWholeSubtree {
            for element in self.descendants {
                element.setElementInfo()
            }
        }
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
    
}

/// The information about the position fo a node first searches for the attachment of name `xpath` for the XPath
/// and (optionally) for the attachment of name `element` for the description for the element up in the tree
/// (including the node itself) before constructing an informatuion based on the current tree.
///  You might use the extension `setElementInfo(forWholeSubtree:)` to `XElement` to set those attachments in the application.
func itemPositionInfo(for node: XNode?) -> String? {
    guard let xPath = (node?.ancestors.reversed().filter{ $0.attached["xpath-barrier"] as? Bool == true }.first ?? node)?.xPathConsideringAttached else { return nil }
    if xPath.hasPrefix("/") {
        return " (\(xPath))"
    } else {
        return nil
    }
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: [String]) {
        log(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) {
        log(message, node: node, arguments)
    }
    
    func log(setPIWithTarget piTarget: String?, _ message: Message, node: XNode?, _ arguments: [String]) {
        let info = logAndUseInfo(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
        if let piTarget {
            (node as? XElement)?.addFirst { XProcessingInstruction(target: piTarget, data: "'\(info)'") }
        }
    }
    
    func log(setPIWithTarget piTarget: String?, _ message: Message, node: XNode?, _ arguments: String...) {
        log(setPIWithTarget: piTarget, message, node: node, arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: [String]) -> String {
        logAndUseInfo(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: String...) -> String {
        logAndUseInfo(message, node: node, arguments)
    }
    
}
