import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    return (node as? XElement)?.xPath ?? node?.parent?.xPath
}

func itemPositionInfo(for node: XNode?) -> String? {
    positionInfo(forNode: node)?.appending(((node as? XText)?.parent ?? node)?.description.prepending(" (").appending(")"))
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) {
        log(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: String...) -> String {
        logAndUseInfo(message, itemPositionInfo: itemPositionInfo(for: node), withArguments: arguments)
    }
    
}
