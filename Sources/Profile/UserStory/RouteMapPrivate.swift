//
//  RouteMapPrivate.swift
//  
//
//  Created by Арман Чархчян on 23.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import PostsRouteMap
import ModelInterfaces
import SettingsRouteMap

protocol RouteMapPrivate: AnyObject {
    func currentAccountProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule
    func someProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule
    func postsModule(userID: String) -> PostsModule
    func currentAccountPostsModule(userID: String) -> PostsModule
    func accountSettingsModule() -> SettingsModule
}
