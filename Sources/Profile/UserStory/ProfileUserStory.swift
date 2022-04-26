//
//  ProfileUserStory.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Swinject
import Foundation
import Module
import Managers
import AlertManager

public protocol ProfileRouteMap: AnyObject {
    func currentAccountModule(profile: ProfileModelProtocol) -> ProfileModule
    func friendAccountModule(profile: ProfileModelProtocol) -> ProfileModule
}

public final class ProfileUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension ProfileUserStory: ProfileRouteMap {
    public func friendAccountModule(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .friend(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func currentAccountModule(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .root(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension ProfileUserStory: RouteMapPrivate {
    func currentAccountProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .root(profile),
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
    
    func friendProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .friend(profile),
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
