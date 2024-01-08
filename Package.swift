// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorkflowUtilitiesForSwiftXML",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WorkflowUtilitiesForSwiftXML",
            targets: ["WorkflowUtilitiesForSwiftXML"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/stefanspringer1/SwiftXML", from: "1.2.372"),
        .package(url: "https://github.com/stefanspringer1/SwiftWorkflow", from: "1.2.202"),
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
