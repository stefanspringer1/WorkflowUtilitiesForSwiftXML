// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkflowUtilitiesForSwiftXML",
    platforms: [
        .macOS(.v15),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WorkflowUtilitiesForSwiftXML",
            targets: ["WorkflowUtilitiesForSwiftXML"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/swiftxml/SwiftXML.git", from: "2.0.9"),
        .package(url: "https://github.com/stefanspringer1/SwiftWorkflow", from: "6.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WorkflowUtilitiesForSwiftXML",
            dependencies: [
                "SwiftXML",
                .product(name: "Workflow", package: "SwiftWorkflow"),
            ]),
        .testTarget(
            name: "WorkflowUtilitiesForSwiftXMLTests",
            dependencies: ["WorkflowUtilitiesForSwiftXML"]),
    ]
)
