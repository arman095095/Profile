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
import ModelInterfaces

protocol ProfileInfoModuleOutput: AnyObject {
    func openAccountSettings()
}

protocol ProfileInfoModuleInput: AnyObject { }

protocol ProfileInfoViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func showPosts()
    func showAccountSettings()
    func showMenu()
    func denyAction()
    func acceptAction()
}

enum InputFlowContext {
    case root(ProfileModelProtocol)
    case some(ProfileModelProtocol)
}

final class ProfileInfoPresenter {
    
    weak var view: ProfileInfoViewInput?
    weak var output: ProfileInfoModuleOutput?
    private let router: ProfileInfoRouterInput
    private let interactor: ProfileInfoInteractorInput
    private let context: InputFlowContext
    private let alertManager: AlertManagerProtocol
    private let stringFactory: ProfileStringFactoryProtocol
    private var profile: ProfileInfoViewModelProtocol?
    private var state: ProfileState?
    
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
        guard let profileID = profile?.id else { return }
        interactor.refreshProfileInfo(userID: profileID)
        guard case .root = context else { return }
        view?.setupNavigationBar(on: false)
    }
    
    func viewWillDisappear() {
        guard case .root = context else { return }
        view?.setupNavigationBar(on: true)
    }
    
    func viewDidLoad() {
        switch context {
        case .root(let dto):
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            self.state = .currentAccount
            self.profile = model
            view?.setupInitialStateCurrentAccount(stringFactory: stringFactory)
        case .some(let dto):
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            let state = interactor.determinateState(with: model.id)
            self.state = state
            self.profile = model
            switch state {
            case .friend:
                view?.setupInitialStateFriendProfile(stringFactory: stringFactory)
            case .alreadySended:
                view?.setupInitialStateFriendProfile(stringFactory: stringFactory)
            case .send:
                view?.setupInitialStateSendOffer(stringFactory: stringFactory)
            case .request:
                view?.setupInitialStateRecievedOffer(stringFactory: stringFactory)
            case .currentAccount:
                view?.setupInitialStateCurrentAccount(stringFactory: stringFactory)
            case .removed:
                self.profile = RemovedProfileViewModel(id: dto.id)
                view?.setupInitialStateFriendProfile(stringFactory: stringFactory)
            }
        }
        guard let profile = self.profile else { return }
        view?.fillInfo(with: profile)
    }
    
    func showPosts() {
        guard let profileID = profile?.id else { return }
        guard case .root = context else {
            router.openPostsModule(userID: profileID)
            return
        }
        router.openCurrentAccountPostsModule(userID: profileID)
    }

    func showAccountSettings() {
        output?.openAccountSettings()
    }

    func showMenu() {
        guard let profileID = profile?.id else { return }
        let isBlocked = interactor.isBlocked(profileID: profileID)
        router.openBlockingMenu(blocked: isBlocked, stringFactory: stringFactory)
    }
    
    func denyAction() {
        guard case .some = context,
              let state = state else { return }
        switch state {
        case .send:
            // TO DO
            break
        case .request:
            // TO DO
            break
        default:
            break
        }
    }
    
    func acceptAction() {
        guard case .some = context,
              let state = state else { return }
        switch state {
        case .send:
            // TO DO
            break
        case .request:
            // TO DO
            break
        default:
            break
        }
    }
}

extension ProfileInfoPresenter: ProfileInfoRouterOutput {
    func blockProfile() {
        guard let profileID = profile?.id else { return }
        interactor.block(profileID: profileID)
    }
    
    func unblockProfile() {
        guard let profileID = profile?.id else { return }
        interactor.unblock(profileID: profileID)
    }
}

extension ProfileInfoPresenter: ProfileInfoInteractorOutput {
    
    func successResponse(profile: ProfileModelProtocol) {
        guard let model = profile as? ProfileInfoViewModelProtocol else { return }
        self.profile = model
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
