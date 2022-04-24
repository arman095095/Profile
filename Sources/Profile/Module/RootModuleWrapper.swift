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
    
}

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    weak var output: ProfileModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }

    func view() -> UIViewController {
        let module = routeMap.//
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: ProfileModuleInput {
    
}
