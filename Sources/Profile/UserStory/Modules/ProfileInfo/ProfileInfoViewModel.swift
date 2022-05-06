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

protocol ProfileInfoViewModelProtocol {
    var title: String { get }
    var imageURL: URL? { get }
    var nameAndAge: String { get }
    var countryCity: String { get }
    var info: String { get }
    var postsCount: Int { get }
    var id: String { get }
}

extension ProfileModel: ProfileInfoViewModelProtocol {

    var title: String {
        self.userName
    }
    
    var imageURL: URL? {
        URL(string: self.imageUrl)
    }
    
    var nameAndAge: String {
        "\(self.userName), \(DateFormatService().getAge(date: self.birthday))"
    }
    
    var countryCity: String {
        "\(self.country), \(self.city)"
    }
}

final class RemovedProfileViewModel: ProfileInfoViewModelProtocol {
    var title: String = "Профиль удален"
    var imageURL: URL? = URL(string: "https://okeygeek.ru/wp-content/uploads/2017/07/sobaka.jpg")
    var nameAndAge: String = "DELETED"
    var countryCity: String = ""
    var info: String = "Пользователь удалил свой профиль"
    var postsCount: Int = 0
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
