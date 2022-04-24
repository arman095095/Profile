//
//  ProfileUserStory.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Swinject
import Module

public protocol ProfileRouteMap: AnyObject {
    func rootModule() -> ModuleProtocol
}

public final class ProfileUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension ProfileUserStory: ProfileRouteMap {
    public func rootModule() -> ModuleProtocol {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension ProfileUserStory: RouteMapPrivate {
    func module() -> ModuleProtocol {
        let module =
        module._output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
