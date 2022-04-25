//
//  RootModuleWrapperAssembly.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias ProfileModule = Module<ProfileModuleInput, ProfileModuleOutput>

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate, context: InputFlowContext) -> ProfileModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap, flow: context)
        return ProfileModule(input: wrapper, view: wrapper.view()) {
            wrapper.output = $0
        }
    }
}
