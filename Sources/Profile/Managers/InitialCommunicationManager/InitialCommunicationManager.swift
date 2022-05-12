//
//  File.swift
//  
//
//  Created by Арман Чархчян on 06.05.2022.
//

import Foundation
import ModelInterfaces
import NetworkServices
import Services

protocol InitialCommunicationManagerProtocol {
    func requestCommunication(userID: String)
    func acceptRequestCommunication(userID: String, completion: @escaping (Result<Void, Error>) -> ())
    func denyRequestCommunication(userID: String)
}

final class InitialCommunicationManager {
    
    private let accountID: String
    private let account: AccountModelProtocol
    private let requestsService: RequestsServiceProtocol
    private let cacheService: AccountCacheServiceProtocol
    
    init(accountID: String,
         account: AccountModelProtocol,
         requestsService: RequestsServiceProtocol,
         cacheService: AccountCacheServiceProtocol) {
        self.account = account
        self.accountID = accountID
        self.requestsService = requestsService
        self.cacheService = cacheService
    }
}

extension InitialCommunicationManager: InitialCommunicationManagerProtocol {
    
    func denyRequestCommunication(userID: String) {
        requestsService.deny(toID: userID, fromID: accountID) { _ in }
    }
    
    func acceptRequestCommunication(userID: String, completion: @escaping (Result<Void, Error>) -> ()) {
        requestsService.accept(toID: userID, fromID: accountID) { _ in }
    }
    
    func requestCommunication(userID: String) {
        requestsService.send(toID: userID, fromID: accountID) { result in
            switch result {
            case .success:
                self.account.requestIds.insert(userID)
                self.cacheService.store(accountModel: self.account)
            case .failure:
                break
            }
        }
    }
}

