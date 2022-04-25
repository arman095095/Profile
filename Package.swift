// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
        .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
        .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
        .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
        .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Profile",
            dependencies: [.product(name: "Swinject", package: "Swinject"),
                           .product(name: "SDWebImage", package: "SDWebImage"),
                           .product(name: "Module", package: "Module"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "AlertManager", package: "AlertManager"),
                           .product(name: "Utils", package: "Utils")])
    ]
)
