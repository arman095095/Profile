//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import NetworkServices
import Services
import Managers
import ModelInterfaces

final class BlockingManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BlockingManagerProtocol.self) { r in
            guard let accountID = r.resolve(QuickAccessManagerProtocol.self)?.userID,
                  let account = r.resolve(AccountModelProtocol.self),
                  let accountService = r.resolve(AccountNetworkServiceProtocol.self),
                  let cacheService = r.resolve(AccountCacheServiceProtocol.self),
                  let profileService = r.resolve(ProfileInfoNetworkServiceProtocol.self),
                  let accountInfoNetworkService = r.resolve(AccountContentNetworkServiceProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return BlockingManager(account: account,
                                   accountID: accountID,
                                   accountService: accountService,
                                   profileService: profileService,
                                   cacheService: cacheService,
                                   accountInfoNetworkService: accountInfoNetworkService)
        }.inObjectScope(.weak)
    }
}
