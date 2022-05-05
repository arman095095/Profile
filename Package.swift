// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
]

private let remoteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/ProfileRouteMap.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/UserStoryFacade.git", branch: "develop")
]

private let localDependencies: [Package.Dependency] = [
    .package(path: "../Managers"),
    .package(path: "../Module"),
    .package(path: "../DesignSystem"),
    .package(path: "../AlertManager"),
    .package(path: "../Utils"),
    .package(path: "../ProfileRouteMap"),
    .package(path: "../UserStoryFacade")
]

let isDev = true
isDev ? dependencies.append(contentsOf: localDependencies) : dependencies.append(contentsOf: remoteDependencies)

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: dependencies,
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
                           .product(name: "Utils", package: "Utils"),
                           .product(name: "ProfileRouteMap", package: "ProfileRouteMap"),
                           .product(name: "UserStoryFacade", package: "UserStoryFacade")])
    ]
)
