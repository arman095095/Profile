//
//  ProfileInfoInteractor.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol ProfileInfoInteractorInput: AnyObject {
    func isBlocked(profileID: String) -> Bool
    func block(profileID: String)
    func unblock(profileID: String)
}

protocol ProfileInfoInteractorOutput: AnyObject {
    func successBlocked()
    func successUnblocked()
    func failureBlock(message: String)
    func failureUnblock(message: String)
}

final class ProfileInfoInteractor {
    
    weak var output: ProfileInfoInteractorOutput?
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}

extension ProfileInfoInteractor: ProfileInfoInteractorInput {
    func block(profileID: String) {
        authManager.blockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successBlocked()
            case .failure(let error):
                self?.output?.failureBlock(message: error.localizedDescription)
            }
        }
    }
    
    func unblock(profileID: String) {
        authManager.unblockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successUnblocked()
            case .failure(let error):
                self?.output?.failureUnblock(message: error.localizedDescription)
            }
        }
    }
    
    func isBlocked(profileID: String) -> Bool {
        authManager.isProfileBlocked(userID: profileID)
    }
}
