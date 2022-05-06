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

    public func offerSendProfile(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .sendOffer(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func offerRecieveProfile(profile: ProfileModelProtocol) -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .recievedOffer(profile))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func offersSendingProfilesList() -> ProfileModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .sendOfferList)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
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

    func recievedOfferProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .recievedOffer(profile),
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
    
    func sendOfferProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .sendOffer(profile),
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
    
    func sendOfferListProfileModule() -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .sendOfferList,
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    accountManager: accountManager,
                                                    profilesManager: profilesManager)
        module.output = outputWrapper
        return module
    }
    
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
    
    func friendProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let accountManager = safeResolver.resolve(AccountManagerProtocol.self),
              let profilesManager = safeResolver.resolve(ProfilesManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .friend(profile),
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
