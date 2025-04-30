import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    (node as? XElement)?.xPath ?? node?.parent?.xPath
}

public extension XElement {
    
    /// Use this extension to `XElement` to set the attachments `xpath` and `element` to be used for error messages.
    func setElementInfo() {
        if self.attached["xpath"] == nil { self.attached["xpath"] = self.xPath }
        if self.attached["element"] == nil { self.attached["element"] = self.description }
    }
    
}

/// The information about the position fo a node first searches for the attachment of name `xpath` for the XPath
/// and (optionally) for the attachment of name `element` for the description for the element up in the tree
/// (including the node itself) before constructing an informatuion based on the current tree.
///  You might use the extension `setElementInfo()` to `XElement` to set those attachments in the application.
func itemPositionInfo(for node: XNode?) -> String? {
    node?.ancestorsIncludingSelf.compactMap{ ($0.attached["xpath"] as? String)?.appending(($0.attached["element"] as? String)?.prepending(" (").appending(")")) }.first ??
    positionInfo(forNode: node)?.appending(((node as? XText)?.parent ?? node)?.description.prepending(" (").appending(")"))
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) {
        log(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
    func log(setPIWithTarget piTarget: String, _ message: Message, node: XNode?, _ arguments: String...) {
        let info = logAndUseInfo(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
        (node as? XElement)?.addFirst { XProcessingInstruction(target: piTarget, data: "'\(info)'") }
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: String...) -> String {
        logAndUseInfo(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
}
