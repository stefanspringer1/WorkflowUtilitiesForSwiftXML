import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    return (node as? XElement)?.xpath ?? node?.parent?.xpath
}

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) async -> () {
        await log(message: message, itemPositionInfo: positionInfo(forNode: node), arguments: arguments)
    }
    
}

public extension SynchronousCollectingLogger {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) -> () {
        self.log(message: message, itemPositionInfo: positionInfo(forNode: node), arguments: arguments)
    }
    
}
