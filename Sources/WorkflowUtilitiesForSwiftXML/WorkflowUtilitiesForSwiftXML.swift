import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    (node as? XElement)?.xPath ?? node?.parent?.xPath
}

/// The information about the position fo a node first searches for the attachment of name `xpath`
/// up in the tree (including the node itself) before constructing an informatuion based on the current tree.
func itemPositionInfo(for node: XNode?) -> String? {
    node?.ancestorsIncludingSelf.map{ $0.attached["xpath"] as? String }.first ??
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
