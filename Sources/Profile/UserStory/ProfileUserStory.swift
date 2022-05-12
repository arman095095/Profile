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
import SettingsRouteMap
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

    func accountSettingsModule() -> SettingsModule {
        guard let module = container
            .synchronize()
            .resolve(UserStoryFacadeProtocol.self)?
            .settingsUserStory?
            .rootModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        module.output = outputWrapper?.output as? SettingsModuleOutput
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
              let communicationManager = safeResolver.resolve(InitialCommunicationManagerProtocol.self),
              let profileInfoManager = safeResolver.resolve(UserInfoManagerProtocol.self),
              let blockingManager = safeResolver.resolve(BlockingManagerProtocol.self),
              let determinator = safeResolver.resolve(ProfileStateDeterminator.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .root(profile),
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    communicationManager: communicationManager,
                                                    profileInfoManager: profileInfoManager,
                                                    profileStateDeterminator: determinator,
                                                    blockingManager: blockingManager)
        module.output = outputWrapper
        return module
    }
    
    func someProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule {
        let safeResolver = container.synchronize()
        guard let alertManager = safeResolver.resolve(AlertManagerProtocol.self),
              let communicationManager = safeResolver.resolve(InitialCommunicationManagerProtocol.self),
              let profileInfoManager = safeResolver.resolve(UserInfoManagerProtocol.self),
              let blockingManager = safeResolver.resolve(BlockingManagerProtocol.self),
              let determinator = safeResolver.resolve(ProfileStateDeterminator.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfileInfoAssembly.makeModule(context: .some(profile),
                                                    routeMap: self,
                                                    alertManager: alertManager,
                                                    communicationManager: communicationManager,
                                                    profileInfoManager: profileInfoManager,
                                                    profileStateDeterminator: determinator,
                                                    blockingManager: blockingManager)
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
