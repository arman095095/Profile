//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import ModelInterfaces

public protocol ProfileStateDeterminatorProtocol {
    func isProfileFriend(userID: String) -> Bool
    func isProfileBlocked(userID: String) -> Bool
    func isProfileWaiting(userID: String) -> Bool
    func isProfileRequested(userID: String) -> Bool
}

public final class ProfileStateDeterminator {
    
    private let account: AccountModelProtocol
    
    public init(account: AccountModelProtocol) {
        self.account = account
    }
}

extension ProfileStateDeterminator: ProfileStateDeterminatorProtocol {
    
    public func isProfileFriend(userID: String) -> Bool {
        account.friendIds.contains(userID)
    }
    
    public func isProfileWaiting(userID: String) -> Bool {
        account.waitingsIds.contains(userID)
    }
    
    public func isProfileRequested(userID: String) -> Bool {
        account.requestIds.contains(userID)
    }
    
    public func isProfileBlocked(userID: String) -> Bool {
        account.blockedIds.contains(userID)
    }
}
