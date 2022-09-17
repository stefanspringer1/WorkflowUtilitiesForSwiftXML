import Foundation

import SwiftXML
import Workflow

@inline(__always)
func positionInfo(forNode node: XNode?) -> String? {
    return (node as? XElement)?.xpath ?? node?.parent?.xpath
}

@available(macOS 10.15, *)
public extension Execution {
    
    func log(_ message: Message, node: XNode?, _ arguments: String...) -> () {
        log(message: message, itemPositionInfo: positionInfo(forNode: node), arguments: arguments)
    }
    
}
