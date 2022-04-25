//
//  ProfileInfoPresenter.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import AlertManager

protocol ProfileInfoModuleOutput: AnyObject {
    func openAccountSettings()
}

protocol ProfileInfoModuleInput: AnyObject { }

protocol ProfileInfoViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func showPosts()
    func showAccountSettings()
    func showMenu()
}

enum InputFlowContext {
    case root(ProfileModelProtocol)
    case friend(ProfileModelProtocol)
    case recievedOffer(ProfileModelProtocol)
    case sendOfferList(ProfileModelProtocol)
    case sendOffer(ProfileModelProtocol)
}

final class ProfileInfoPresenter {
    
    weak var view: ProfileInfoViewInput?
    weak var output: ProfileInfoModuleOutput?
    private let router: ProfileInfoRouterInput
    private let interactor: ProfileInfoInteractorInput
    private let context: InputFlowContext
    private let alertManager: AlertManagerProtocol
    private let stringFactory: ProfileStringFactoryProtocol
    private var currentProfile: ProfileInfoViewModelProtocol?
    
    init(router: ProfileInfoRouterInput,
         interactor: ProfileInfoInteractorInput,
         context: InputFlowContext,
         stringFactory: ProfileStringFactoryProtocol,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.context = context
        self.stringFactory = stringFactory
        self.alertManager = alertManager
    }
}

extension ProfileInfoPresenter: ProfileInfoViewOutput {

    func viewWillAppear() {
        guard let profileID = currentProfile?.id else { return }
        interactor.refreshProfileInfo(userID: profileID)
    }
    
    func viewDidLoad() {
        switch context {
        case .root(let dto):
            view?.setupInitialStateForCurrent(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        case .friend(let dto):
            view?.setupInitialStateForFriend(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        default:
            break
        }
    }
    
    func showPosts() {
        
    }

    func showAccountSettings() {
        output?.openAccountSettings()
    }

    func showMenu() {
        guard let profileID = currentProfile?.id else { return }
        let isBlocked = interactor.isBlocked(profileID: profileID)
        router.openBlockingMenu(blocked: isBlocked, stringFactory: stringFactory)
    }
}

extension ProfileInfoPresenter: ProfileInfoRouterOutput {
    func blockProfile() {
        guard let profileID = currentProfile?.id else { return }
        interactor.block(profileID: profileID)
    }
    
    func unblockProfile() {
        guard let profileID = currentProfile?.id else { return }
        interactor.unblock(profileID: profileID)
    }
}

extension ProfileInfoPresenter: ProfileInfoInteractorOutput {
    func successResponse(profile: ProfileModelProtocol) {
        guard let model = profile as? ProfileInfoViewModelProtocol else { return }
        currentProfile = model
        view?.fillInfo(with: model)
    }
    
    func failureProfileResponse(message: String) {
        alertManager.present(type: .error, title: message)
    }
    
    func successBlocked() {
        alertManager.present(type: .success, title: stringFactory.successBlockedMessage)
    }
    
    func successUnblocked() {
        alertManager.present(type: .success, title: stringFactory.successUnblockedMessage)
    }
    
    func failureBlock(message: String) {
        alertManager.present(type: .error, title: message)
    }
    
    func failureUnblock(message: String) {
        alertManager.present(type: .error, title: message)
    }
}

extension ProfileInfoPresenter: ProfileInfoModuleInput {
    
}