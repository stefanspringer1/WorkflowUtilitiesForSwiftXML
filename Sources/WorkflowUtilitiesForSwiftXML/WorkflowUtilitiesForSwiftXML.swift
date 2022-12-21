import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    return (node as? XElement)?.xPath ?? node?.parent?.xPath
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) -> () {
        log(message, itemPositionInfo: positionInfo(forNode: node), withArguments: arguments)
    }
    
}
