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
    private let communicationService: CommunicationNetworkServiceProtocol
    private let cacheService: AccountCacheServiceProtocol
    
    init(accountID: String,
         account: AccountModelProtocol,
         communicationService: CommunicationNetworkServiceProtocol,
         cacheService: AccountCacheServiceProtocol) {
        self.account = account
        self.accountID = accountID
        self.communicationService = communicationService
        self.cacheService = cacheService
    }
}

extension InitialCommunicationManager: InitialCommunicationManagerProtocol {
    
    func denyRequestCommunication(userID: String) {
        communicationService.deny(toID: userID, fromID: accountID) { _ in }
    }
    
    func acceptRequestCommunication(userID: String, completion: @escaping (Result<Void, Error>) -> ()) {
        communicationService.accept(toID: userID, fromID: accountID) { _ in }
    }
    
    func requestCommunication(userID: String) {
        communicationService.send(toID: userID, fromID: accountID) { result in
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

