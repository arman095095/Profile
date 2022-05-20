//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import Swinject
import NetworkServices

public final class UserInfoManagerAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        container.register(UserInfoManagerProtocol.self) { r in
            guard let profilesService = r.resolve(ProfilesNetworkServiceProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
            return UserInfoManager(profileService: profilesService)
        }.inObjectScope(.weak)
    }
}
