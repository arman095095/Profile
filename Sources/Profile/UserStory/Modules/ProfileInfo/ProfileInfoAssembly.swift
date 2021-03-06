//
//  ProfileInfoAssembly.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import AlertManager
import Managers

typealias ProfileInfoModule = Module<ProfileInfoModuleInput, ProfileInfoModuleOutput>

enum ProfileInfoAssembly {
    static func makeModule(context: InputFlowContext,
                           routeMap: RouteMapPrivate,
                           alertManager: AlertManagerProtocol,
                           communicationManager: InitialCommunicationManagerProtocol,
                           profileInfoManager: UserInfoManagerProtocol,
                           profileStateDeterminator: ProfileStateDeterminator,
                           blockingManager: BlockingManagerProtocol) -> ProfileInfoModule {
        let view = ProfileInfoViewController()
        let router = ProfileInfoRouter(routeMap: routeMap)
        let interactor = ProfileInfoInteractor(communicationManager: communicationManager,
                                               profileInfoManager: profileInfoManager,
                                               profileStateDeterminator: profileStateDeterminator,
                                               blockingManager: blockingManager)
        let stringFactory = ProfileStringFactory()
        let presenter = ProfileInfoPresenter(router: router,
                                             interactor: interactor,
                                             context: context,
                                             stringFactory: stringFactory,
                                             alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        router.output = presenter
        return ProfileInfoModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
