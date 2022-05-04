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

protocol RouteMapPrivate: AnyObject {
    func currentAccountProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule
    func friendProfileModule(profile: ProfileModelProtocol) -> ProfileInfoModule
    func postsModule(userID: String) -> PostsModule
    /*func recievedOfferProfileModule() -> ProfileInfoModule
    func sendOfferProfileModule() -> ProfileInfoModule
    func sendOfferListProfileModule() -> ProfileInfoModule*/
}
