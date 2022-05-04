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
    func openPostsModule(userID: String)
}

protocol ProfileInfoRouterOutput: AnyObject {
    func blockProfile()
    func unblockProfile()
}

final class ProfileInfoRouter {
    weak var transitionHandler: UIViewController?
    weak var output: ProfileInfoRouterOutput?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension ProfileInfoRouter: ProfileInfoRouterInput {

    func openPostsModule(userID: String) {
        let module = routeMap.postsModule(userID: userID)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
    
    func openBlockingMenu(blocked: Bool,
                          stringFactory: ProfileStringFactoryProtocol) {
        let message = blocked ? stringFactory.unblockSubtitle : stringFactory.blockSubtitle
        let acceptButtonTitle = blocked ? stringFactory.unblockButtonTitle : stringFactory.blockButtonTitle
        transitionHandler?.showAlertDestructive(title: stringFactory.blockingTitle,
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
