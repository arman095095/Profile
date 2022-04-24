//
//  ProfileStringFactory.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//

import Foundation

protocol ProfileStringFactoryProtocol {
    var menuButtonImageName: String { get }
    var settingsButtonImageName: String { get }
    var postsButtonTitle: String { get }
    var showButtonTitle: String { get }
    var successOfferSendedMessage: String { get }
    var blockTitle: String { get }
    var unblockTitle: String { get }
    var blockSubtitle: String { get }
    var unblockSubtitle: String { get }
}

struct ProfileStringFactory: ProfileStringFactoryProtocol {
    var menuButtonImageName = "menu2"
    var settingsButtonImageName = "settings2"
    var postsButtonTitle = "Посты"
    var showButtonTitle = "Показать"
    var successOfferSendedMessage = "Запрос отправлен"
    var blockTitle = "Заблокировать"
    var unblockTitle = "Разблокировать"
    var blockSubtitle = "Вы уверены, что хотите заблокировать пользователя?"
    var unblockSubtitle = "Вы уверены, что хотите разблокировать пользователя?"
}
