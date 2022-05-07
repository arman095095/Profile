//
//  SendMessageViewModel.swift
//  diffibleData
//
//  Created by Arman Davidoff on 15.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Managers
import Utils
import Foundation
import ModelInterfaces

protocol ProfileInfoViewModelProtocol {
    var title: String { get }
    var imageURL: URL? { get }
    var nameAndAge: String { get }
    var countryCity: String { get }
    var info: String { get }
    var postsCount: String { get }
    var id: String { get }
}

final class ProfileInfoViewModel {
    
    private var profile: ProfileModelProtocol
    
    init(profile: ProfileModelProtocol) {
        self.profile = profile
    }
}

extension ProfileInfoViewModel: ProfileInfoViewModelProtocol {
    
    var info: String {
        !profile.removed ? profile.info : RemovedProfileConstants.info.rawValue
    }
    
    var postsCount: String {
        !profile.removed ? String(profile.postsCount) : RemovedProfileConstants.postsCount.rawValue
    }
    
    var id: String {
        profile.id
    }
    
    var title: String {
        !profile.removed ? profile.userName : RemovedProfileConstants.title.rawValue
    }
    
    var imageURL: URL? {
        !profile.removed ? URL(string: profile.imageUrl): URL(string: RemovedProfileConstants.imageURL.rawValue)
    }
    
    var nameAndAge: String {
        !profile.removed ? "\(profile.userName), \(DateFormatService().getAge(date: profile.birthday))" : RemovedProfileConstants.name.rawValue
    }
    
    var countryCity: String {
        "\(profile.country), \(profile.city)"
    }
}
