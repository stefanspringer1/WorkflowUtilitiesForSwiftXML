import Foundation

import SwiftXML
import Workflow

public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) async -> () {
        await log(message: message, itemPositionInfo: (node as? XElement)?.xpath ?? node?.parent?.xpath, arguments: arguments)
    }
    
}

public extension SynchronousCollectingLogger {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) -> () {
        self.log(message: message, itemPositionInfo: (node as? XElement)?.xpath ?? node?.parent?.xpath, arguments: arguments)
    }
    
}
