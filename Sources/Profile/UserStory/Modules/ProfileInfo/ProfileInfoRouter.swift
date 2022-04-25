//
//  ProfileInfoRouter.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager

protocol ProfileInfoRouterInput: AnyObject {
    func openBlockingMenu(blocked: Bool,
                          stringFactory: ProfileStringFactoryProtocol)
}

protocol ProfileInfoRouterOutput: AnyObject {
    func blockProfile()
    func unblockProfile()
}

final class ProfileInfoRouter {
    weak var transitionHandler: UIViewController?
    weak var output: ProfileInfoRouterOutput?
}

extension ProfileInfoRouter: ProfileInfoRouterInput {
    func openBlockingMenu(blocked: Bool,
                          stringFactory: ProfileStringFactoryProtocol) {
        let message = blocked ? stringFactory.unblockSubtitle : stringFactory.blockSubtitle
        let acceptButtonTitle = blocked ? stringFactory.unblockButtonTitle : stringFactory.blockButtonTitle
        transitionHandler?.showAlert(title: stringFactory.blockingTitle,
                                     message: message,
                                     acceptButtonTitle: acceptButtonTitle,
                                     cancelButtonTitle: stringFactory.cancelButtonTitle,
                                     acceptHandler: {
            !blocked ?
            self.output?.blockProfile() :
            self.output?.unblockProfile()
        },
                                     denyHandler: { })
    }
}
