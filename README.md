# WorkflowUtilitiesForSwiftXML

Some definitions useful when working with [SwiftXML](https://github.com/stefanspringer1/SwiftXML) in the context of [SwiftWorkflow](https://github.com/stefanspringer1/SwiftWorkflow). 

The information about the position fo a node first searches for the attachment of name `xpath` for the XPath and (optionally) for the attachment of name `element` for the description for the element up in the tree (including the node itself) before constructing an informatuion based on the current tree. You might use the extension `setElementInfo()` to `XElement` to set those attachments in the application.
