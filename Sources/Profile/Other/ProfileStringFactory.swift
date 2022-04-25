//
//  ProfileStringFactory.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//

import Foundation

protocol ProfileStringFactoryProtocol {
    var currentAccountTitle: String { get }
    var menuButtonImageName: String { get }
    var settingsButtonImageName: String { get }
    var postsButtonTitle: String { get }
    var showButtonTitle: String { get }
    var successOfferSendedMessage: String { get }
    var blockButtonTitle: String { get }
    var unblockButtonTitle: String { get }
    var blockSubtitle: String { get }
    var unblockSubtitle: String { get }
    var cancelButtonTitle: String { get }
    var blockingTitle: String { get }
    var successBlockedMessage: String { get }
    var successUnblockedMessage: String { get }
}

struct ProfileStringFactory: ProfileStringFactoryProtocol {
    var currentAccountTitle = "Ваш профиль"
    var blockingTitle = "Блокировка"
    var menuButtonImageName = "menu2"
    var settingsButtonImageName = "settings2"
    var postsButtonTitle = "Посты"
    var showButtonTitle = "Показать"
    var successOfferSendedMessage = "Запрос отправлен"
    var blockButtonTitle = "Заблокировать"
    var unblockButtonTitle = "Разблокировать"
    var blockSubtitle = "Вы уверены, что хотите заблокировать пользователя?"
    var unblockSubtitle = "Вы уверены, что хотите разблокировать пользователя?"
    var successBlockedMessage = "Пользователь успешно заблокирован"
    var successUnblockedMessage = "Пользователь успешно разблокирован"
    var cancelButtonTitle = "Отмена"
}
