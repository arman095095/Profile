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
    case nothing
    case wait
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
    private let communicationManager: InitialCommunicationManagerProtocol
    private let profileInfoManager: UserInfoManagerProtocol
    private let profileStateDeterminator: ProfileStateDeterminator
    private let blockingManager: BlockingManagerProtocol
    
    init(communicationManager: InitialCommunicationManagerProtocol,
         profileInfoManager: UserInfoManagerProtocol,
         profileStateDeterminator: ProfileStateDeterminator,
         blockingManager: BlockingManagerProtocol) {
        self.communicationManager = communicationManager
        self.profileInfoManager = profileInfoManager
        self.profileStateDeterminator = profileStateDeterminator
        self.blockingManager = blockingManager
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
        if profileStateDeterminator.isProfileFriend(userID: profile.id) {
            return .friend
        }
        if profileStateDeterminator.isProfileWaiting(userID: profile.id) {
            return .wait
        }
        if profileStateDeterminator.isProfileRequested(userID: profile.id) {
            return .alreadySended
        }
        return .nothing
    }
    
    func refreshProfileInfo(userID: String) {
        profileInfoManager.getProfile(userID: userID) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.output?.successResponse(profile: profile)
            case .failure(let error):
                self?.output?.failureProfileResponse(message: error.localizedDescription)
            }
        }
    }
    
    func block(profileID: String) {
        blockingManager.blockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successBlocked()
            case .failure(let error):
                self?.output?.failureBlock(message: error.localizedDescription)
            }
        }
    }
    
    func unblock(profileID: String) {
        blockingManager.unblockProfile(profileID) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successUnblocked()
            case .failure(let error):
                self?.output?.failureUnblock(message: error.localizedDescription)
            }
        }
    }
    
    func isBlocked(profileID: String) -> Bool {
        profileStateDeterminator.isProfileBlocked(userID: profileID)
    }
}
