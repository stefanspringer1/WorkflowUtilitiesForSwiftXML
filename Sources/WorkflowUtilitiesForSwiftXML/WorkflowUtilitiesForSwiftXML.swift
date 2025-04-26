import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    return (node as? XElement)?.xPath ?? node?.parent?.xPath
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) {
        log(message, itemPositionInfo: positionInfo(forNode: node)?.appending(((node as? XText)?.parent ?? node)?.description.prepending(" (").appending(")")), withArguments: arguments)
    }
    
    func logAndUseInfo(_ message: Message, node: XNode?, _ arguments: String...) -> String {
        logAndUseInfo(message, itemPositionInfo: positionInfo(forNode: node)?.appending(((node as? XText)?.parent ?? node)?.description.prepending(" (").appending(")")), withArguments: arguments)
    }
    
}
