//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import ModelInterfaces

protocol ProfileStateDeterminatorProtocol {
    func isProfileFriend(userID: String) -> Bool
    func isProfileBlocked(userID: String) -> Bool
    func isProfileWaiting(userID: String) -> Bool
    func isProfileRequested(userID: String) -> Bool
}

final class ProfileStateDeterminator {
    
    private let account: AccountModelProtocol
    
    init(account: AccountModelProtocol) {
        self.account = account
    }
}

extension ProfileStateDeterminator: ProfileStateDeterminatorProtocol {
    
    func isProfileFriend(userID: String) -> Bool {
        account.friendIds.contains(userID)
    }
    
    func isProfileWaiting(userID: String) -> Bool {
        account.waitingsIds.contains(userID)
    }
    
    func isProfileRequested(userID: String) -> Bool {
        account.requestIds.contains(userID)
    }
    
    func isProfileBlocked(userID: String) -> Bool {
        account.blockedIds.contains(userID)
    }
}
