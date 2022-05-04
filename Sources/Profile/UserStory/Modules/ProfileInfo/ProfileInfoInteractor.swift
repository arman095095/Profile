//
//  ProfileInfoInteractor.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import ModelInterfaces

protocol ProfileInfoInteractorInput: AnyObject {
    func refreshProfileInfo(userID: String)
    func isBlocked(profileID: String) -> Bool
    func block(profileID: String)
    func unblock(profileID: String)
}

protocol ProfileInfoInteractorOutput: AnyObject {
    func successBlocked()
    func successUnblocked()
    func failureBlock(message: String)
    func failureUnblock(message: String)
    func successResponse(profile: ProfileModelProtocol)
    func failureProfileResponse(message: String)
}

final class ProfileInfoInteractor {
    
    weak var output: ProfileInfoInteractorOutput?
    private let accountManager: AccountManagerProtocol
    private let profilesManager: ProfilesManagerProtocol
    
    init(accountManager: AccountManagerProtocol,
         profilesManager: ProfilesManagerProtocol) {
        self.accountManager = accountManager
        self.profilesManager = profilesManager
    }
}

extension ProfileInfoInteractor: ProfileInfoInteractorInput {
    func refreshProfileInfo(userID: String) {
        profilesManager.getProfile(userID: userID) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.output?.successResponse(profile: profile)
            case .failure(let error):
                self?.output?.failureProfileResponse(message: error.localizedDescription)
            }
        }
    }
    
    func block(profileID: String) {
        accountManager.blockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successBlocked()
            case .failure(let error):
                self?.output?.failureBlock(message: error.localizedDescription)
            }
        }
    }
    
    func unblock(profileID: String) {
        accountManager.unblockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successUnblocked()
            case .failure(let error):
                self?.output?.failureUnblock(message: error.localizedDescription)
            }
        }
    }
    
    func isBlocked(profileID: String) -> Bool {
        accountManager.isProfileBlocked(userID: profileID)
    }
}
