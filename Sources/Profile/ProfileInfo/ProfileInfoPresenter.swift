//
//  ProfileInfoPresenter.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol ProfileInfoModuleOutput: AnyObject { }

protocol ProfileInfoModuleInput: AnyObject { }

protocol ProfileInfoViewOutput: AnyObject {
    func viewDidLoad()
    func showPosts()
    func showAccountSettings()
    func showMenu()
}

enum InputFlowContext {
    case root(ProfileModelProtocol)
    case recievedRequest(ProfileModelProtocol)
    case sendOfferList(ProfileModelProtocol)
    case sendOffer(ProfileModelProtocol)
}

final class ProfileInfoPresenter {
    
    weak var view: ProfileInfoViewInput?
    weak var output: ProfileInfoModuleOutput?
    private let router: ProfileInfoRouterInput
    private let interactor: ProfileInfoInteractorInput
    private let context: InputFlowContext
    private let stringFactory: ProfileStringFactoryProtocol
    
    init(router: ProfileInfoRouterInput,
         interactor: ProfileInfoInteractorInput,
         context: InputFlowContext,
         stringFactory: ProfileStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.context = context
        self.stringFactory = stringFactory
    }
}

extension ProfileInfoPresenter: ProfileInfoViewOutput {
    func viewDidLoad() {
        switch context {
        case .root(let dto):
            view?.setupInitialStateForCurrent(stringFactory: stringFactory)
            guard let viewModel = dto as? ProfileInfoViewModelProtocol else { return }
            view?.fillInfo(with: viewModel)
        case .recievedRequest(let dto):
            view?.setupInitialStateForRecievedRequest(stringFactory: stringFactory)
            guard let viewModel = dto as? ProfileInfoViewModelProtocol else { return }
            view?.fillInfo(with: viewModel)
        case .sendOffer(let dto):
            view?.setupInitialStateForSendOffer(stringFactory: stringFactory)
            guard let viewModel = dto as? ProfileInfoViewModelProtocol else { return }
            view?.fillInfo(with: viewModel)
        case .sendOfferList(let dto):
            view?.setupInitialStateForSendOffer(stringFactory: stringFactory)
            guard let viewModel = dto as? ProfileInfoViewModelProtocol else { return }
            view?.fillInfo(with: viewModel)
        }
    }
    
    func showPosts() {
        
    }

    func showAccountSettings() {
        
    }

    func showMenu() {
        
    }
}

extension ProfileInfoPresenter: ProfileInfoInteractorOutput {
    
}

extension ProfileInfoPresenter: ProfileInfoModuleInput {
    
}
