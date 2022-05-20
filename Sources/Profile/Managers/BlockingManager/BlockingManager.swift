//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//


import Foundation
import Services
import NetworkServices
import ModelInterfaces

public enum BlockingManagerError: LocalizedError {
    case cantBlock
    case cantUnblock
    
    public var errorDescription: String? {
        switch self {
        case .cantBlock:
            return "Не удалось заблокировать пользователя"
        case .cantUnblock:
            return "Не удалось разблокировать пользователя"
        }
    }
}

public protocol BlockingManagerProtocol: AnyObject {
    func blockProfile(_ id: String,
                      completion: @escaping (Result<Void, BlockingManagerError>) -> Void)
    func unblockProfile(_ id: String,
                        completion: @escaping (Result<Void, BlockingManagerError>) -> Void)
}

final class BlockingManager {
    private let account: AccountModelProtocol
    private let accountID: String
    private let accountService: AccountNetworkServiceProtocol
    private let profileService: ProfileInfoNetworkServiceProtocol
    private let cacheService: AccountCacheServiceProtocol
    private let accountInfoNetworkService: AccountContentNetworkServiceProtocol
    
    init(account: AccountModelProtocol,
         accountID: String,
         accountService: AccountNetworkServiceProtocol,
         profileService: ProfileInfoNetworkServiceProtocol,
         cacheService: AccountCacheServiceProtocol,
         accountInfoNetworkService: AccountContentNetworkServiceProtocol) {
        self.account = account
        self.accountID = accountID
        self.accountService = accountService
        self.profileService = profileService
        self.cacheService = cacheService
        self.accountInfoNetworkService = accountInfoNetworkService
    }
}

extension BlockingManager: BlockingManagerProtocol {
    
    public func blockProfile(_ id: String,
                             completion: @escaping (Result<Void, BlockingManagerError>) -> Void) {
        accountService.blockUser(accountID: accountID,
                                 userID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                var errors = [Error]()
                let group = DispatchGroup()
                group.enter()
                self.accountInfoNetworkService.removeFriend(with: id, from: self.accountID) { result in
                    defer { group.leave() }
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        errors.append(error)
                    }
                }
                group.enter()
                self.accountInfoNetworkService.deny(toID: id, fromID: self.accountID) { result in
                    defer { group.leave() }
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        errors.append(error)
                    }
                }
                group.enter()
                self.accountInfoNetworkService.cancelRequest(toID: id, fromID: self.accountID) { result in
                    defer { group.leave() }
                    switch result {
                    case .success():
                        break
                    case .failure(let error):
                        errors.append(error)
                    }
                }
                group.notify(queue: .main) {
                    guard errors.isEmpty else {
                        completion(.failure(.cantBlock))
                        return
                    }
                    self.account.blockedIds.insert(id)
                    self.account.friendIds.remove(id)
                    self.account.waitingsIds.remove(id)
                    self.account.requestIds.remove(id)
                    self.cacheService.store(accountModel: self.account)
                    completion(.success(()))
                }
            case .failure:
                completion(.failure(.cantBlock))
            }
        }
    }
    
    public func unblockProfile(_ id: String,
                               completion: @escaping (Result<Void, BlockingManagerError>) -> Void) {
        accountService.unblockUser(accountID: accountID,
                                   userID: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let firstIndex = self.account.blockedIds.firstIndex(of: id) else { return }
                self.account.blockedIds.remove(at: firstIndex)
                self.cacheService.store(accountModel: self.account)
                completion(.success(()))
            case .failure:
                completion(.failure(.cantUnblock))
            }
        }
    }
}
