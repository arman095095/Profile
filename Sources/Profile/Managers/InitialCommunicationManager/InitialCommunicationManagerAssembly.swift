//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import Swinject
import Managers
import ModelInterfaces
import NetworkServices
import Services

final class InitialCommunicationManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InitialCommunicationManagerProtocol.self) { r in
            guard let accountID = r.resolve(QuickAccessManagerProtocol.self)?.userID,
                  let account = r.resolve(AccountModelProtocol.self),
                  let requestsService = r.resolve(RequestsServiceProtocol.self),
                  let cacheService = r.resolve(AccountCacheServiceProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return InitialCommunicationManager(accountID: accountID,
                                               account: account,
                                               requestsService: requestsService,
                                               cacheService: cacheService)
            
        }.inObjectScope(.weak)
    }
}
