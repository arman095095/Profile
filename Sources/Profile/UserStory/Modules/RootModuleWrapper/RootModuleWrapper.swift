//
//  RootModuleWrapper.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

public protocol ProfileModuleInput: AnyObject {
    
}

public protocol ProfileModuleOutput: AnyObject {
    func openAccountSettingsModule()
}

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    private let flow: InputFlowContext
    weak var output: ProfileModuleOutput?
    
    init(routeMap: RouteMapPrivate, flow: InputFlowContext) {
        self.routeMap = routeMap
        self.flow = flow
    }

    func view() -> UIViewController {
        var module: ProfileInfoModule
        switch flow {
        case .root(let profile):
            module = routeMap.currentAccountProfileModule(profile: profile)
        case .friend(let profile):
            module = routeMap.friendProfileModule(profile: profile)
        case .recievedOffer(let profile):
            module = routeMap.friendProfileModule(profile: profile)
        case .sendOfferList(let profile):
            module = routeMap.friendProfileModule(profile: profile)
        case .sendOffer(let profile):
            module = routeMap.friendProfileModule(profile: profile)
        }
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: ProfileModuleInput {
    
}

extension RootModuleWrapper: ProfileInfoModuleOutput {
    func openAccountSettings() {
        output?.openAccountSettingsModule()
    }
}
