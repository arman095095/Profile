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

enum ProfileState {
    case friend
    case alreadySended
    case send
    case request
    case removed
}

protocol ProfileInfoInteractorInput: AnyObject {
    func refreshProfileInfo(userID: String)
    func isBlocked(profileID: String) -> Bool
    func block(profileID: String)
    func unblock(profileID: String)
    func determinateState(with profile: ProfileModelProtocol) -> ProfileState
    func denyRequest(userID: String)
    func acceptRequest(userID: String)
    func sendRequest(userID: String)
    
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
    private let communicationManager: CommunicationManagerProtocol
    private let profilesManager: ProfilesManagerProtocol
    
    init(communicationManager: CommunicationManagerProtocol,
         profilesManager: ProfilesManagerProtocol) {
        self.communicationManager = communicationManager
        self.profilesManager = profilesManager
    }
}

extension ProfileInfoInteractor: ProfileInfoInteractorInput {

    func denyRequest(userID: String) {
        communicationManager.denyRequestCommunication(userID: userID)
    }
    
    func acceptRequest(userID: String) {
        communicationManager.acceptRequestCommunication(userID: userID) { _ in }
    }
    
    func sendRequest(userID: String) {
        communicationManager.requestCommunication(userID: userID)
    }

    func determinateState(with profile: ProfileModelProtocol) -> ProfileState {
        if profile.removed {
            return .removed
        }
        if communicationManager.isProfileFriend(userID: profile.id) {
            return .friend
        }
        if communicationManager.isProfileWaiting(userID: profile.id) {
            return .request
        }
        if communicationManager.isProfileRequested(userID: profile.id) {
            return .alreadySended
        }
        return .send
    }
    
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
        communicationManager.blockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successBlocked()
            case .failure(let error):
                self?.output?.failureBlock(message: error.localizedDescription)
            }
        }
    }
    
    func unblock(profileID: String) {
        communicationManager.unblockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successUnblocked()
            case .failure(let error):
                self?.output?.failureUnblock(message: error.localizedDescription)
            }
        }
    }
    
    func isBlocked(profileID: String) -> Bool {
        communicationManager.isProfileBlocked(userID: profileID)
    }
}
