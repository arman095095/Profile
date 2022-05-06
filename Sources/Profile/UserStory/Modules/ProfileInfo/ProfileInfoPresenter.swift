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
    case friend(ProfileModelProtocol)
    case recievedOffer(ProfileModelProtocol)
    case sendOfferList
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
    private var profiles: [ProfileInfoViewModelProtocol]?
    
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
            view?.setupInitialStateCurrentAccount(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        case .friend(let dto):
            view?.setupInitialStateFriendProfile(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        case .recievedOffer(let dto):
            view?.setupInitialStateRecievedOffer(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        case .sendOfferList:
            view?.setupInitialStateSendOffer(stringFactory: stringFactory)
            interactor.requestFirstProfiles()
        case .sendOffer(let dto):
            view?.setupInitialStateSendOffer(stringFactory: stringFactory)
            guard let model = dto as? ProfileInfoViewModelProtocol else { return }
            currentProfile = model
            view?.fillInfo(with: model)
        }
    }
    
    func showPosts() {
        guard let profileID = currentProfile?.id else { return }
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
        guard let profileID = currentProfile?.id else { return }
        let isBlocked = interactor.isBlocked(profileID: profileID)
        router.openBlockingMenu(blocked: isBlocked, stringFactory: stringFactory)
    }
    
    func denyAction() {
        switch context {
        case .recievedOffer(_):
            //TO DO
            break
        case .sendOfferList:
            //TO DO
            break
        case .sendOffer(_):
            //TO DO
            break
        default:
            break
        }
    }
    
    func acceptAction() {
        switch context {
        case .recievedOffer(_):
            //TO DO
            break
        case .sendOfferList:
            //TO DO
            break
        case .sendOffer(_):
            //TO DO
            break
        default:
            break
        }
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
    func successLoaded(profiles: [ProfileModelProtocol]) {
        guard case .sendOfferList = context,
              let first = profiles.first as? ProfileInfoViewModelProtocol else { return }
        self.profiles = profiles as? [ProfileInfoViewModelProtocol]
        self.currentProfile = first
        view?.fillInfo(with: first)
    }
    
    func failureLoaded(message: String) {
        guard case .sendOfferList = context else { return }
        alertManager.present(type: .error, title: message)
    }
    
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
