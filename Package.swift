// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiyazakiLife",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MiyazakiLife",
            targets: ["MiyazakiLife"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MiyazakiLife",
            dependencies: [],
            path: "MiyazakiLife"),
    ]
)
