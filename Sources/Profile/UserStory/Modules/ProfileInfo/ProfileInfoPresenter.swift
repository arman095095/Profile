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

@objc
protocol ProfileInfoModuleOutput: AnyObject {
    @objc optional func ignoredProfile()
    @objc optional func deniedProfile()
    @objc optional func acceptedProfile()
    @objc optional func requestedProfile()
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
        setupInitialState()
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
        router.openAccountSettingsModule()
    }

    func showMenu() {
        guard let profileID = profile?.id else { return }
        let isBlocked = interactor.isBlocked(profileID: profileID)
        router.openBlockingMenu(blocked: isBlocked, stringFactory: stringFactory)
    }
    
    func denyAction() {
        guard case .some = context,
              let state = state,
              let profile = profile else { return }
        switch state {
        case .nothing:
            output?.ignoredProfile?()
        case .wait:
            interactor.denyRequest(userID: profile.id)
            output?.deniedProfile?()
        default:
            break
        }
    }
    
    func acceptAction() {
        guard case .some = context,
              let profile = profile else { return }
        switch state {
        case .nothing:
            interactor.sendRequest(userID: profile.id)
            output?.requestedProfile?()
        case .wait:
            interactor.acceptRequest(userID: profile.id)
            output?.acceptedProfile?()
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
        setupUpdatedState(with: profile)
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

private extension ProfileInfoPresenter {
    func setupInitialState() {
        switch context {
        case .root(let profile):
            self.profile = ProfileInfoViewModel(profile: profile)
            view?.setupInitialStateCurrentAccount(stringFactory: stringFactory)
        case .some(let profile):
            self.state = interactor.determinateState(with: profile)
            self.profile = ProfileInfoViewModel(profile: profile)
            switch state {
            case .friend, .removed, .none, .alreadySended:
                view?.setupInitialStateFriendProfile(stringFactory: stringFactory)
            case .nothing:
                view?.setupInitialStateSendOffer(stringFactory: stringFactory)
            case .wait:
                view?.setupInitialStateRecievedOffer(stringFactory: stringFactory)
            }
        }
        guard let profile = self.profile else { return }
        view?.fillInfo(with: profile)
    }
    
    func setupUpdatedState(with profile: ProfileModelProtocol) {
        self.profile = ProfileInfoViewModel(profile: profile)
        guard let profile = self.profile else { return }
        view?.fillInfo(with: profile)
    }
}
