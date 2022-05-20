//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

import Foundation
import Swinject
import FirebaseFirestore

final class AccountContentNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AccountContentNetworkServiceProtocol.self) { r in
            AccountContentNetworkService(networkService: Firestore.firestore())
        }
    }
}
