//
//  ProfileInfoRouter.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileInfoRouterInput: AnyObject {

}

final class ProfileInfoRouter {
    weak var transitionHandler: UIViewController?
}

extension ProfileInfoRouter: ProfileInfoRouterInput {
    
}
