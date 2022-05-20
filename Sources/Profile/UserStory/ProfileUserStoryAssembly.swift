//
//  ProfileUserStoryAssembly.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Swinject
import ProfileRouteMap
import UserStoryFacade

public final class ProfileUserStoryAssembly: Assembly {
    
    public init() { }

    public func assemble(container: Container) {
        ProfileStateDeterminatorAssembly().assemble(container: container)
        UserInfoManagerAssembly().assemble(container: container)
        CommunicationNetworkServiceAssembly().assemble(container: container)
        InitialCommunicationManagerAssembly().assemble(container: container)
        container.register(ProfileRouteMap.self) { r in
            ProfileUserStory(container: container)
        }
    }
}
