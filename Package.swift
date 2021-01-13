// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "GiPyoJohnKim",
    products: [
        .executable(
            name: "GiPyoJohnKim",
            targets: ["GiPyoJohnKim"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "GiPyoJohnKim",
            dependencies: ["Publish", "SplashPublishPlugin"]
        )
    ]
)
