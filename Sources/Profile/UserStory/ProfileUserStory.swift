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
import ProfileRouteMap
import PostsRouteMap
import UserStoryFacade
import ModelInterfaces

public final class ProfileUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension ProfileUserStory: ProfileRouteMap {
    public func rootAccountModule(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .root(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func someAccountModule(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .some(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension ProfileUserStory: RouteMapPrivate {
    
    func currentAccountPostsModule(userID: String) -> PostsModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.postsUserStory?.currentAccountPostsModule(userID: userID) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
    
    func postsModule(userID: String) -> PostsModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.postsUserStory?.userPostsModule(userID: userID) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
    
    func currentAccountProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .root(profile),
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
    
    func someProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .some(profile),
                                                    routeMap: self,
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
