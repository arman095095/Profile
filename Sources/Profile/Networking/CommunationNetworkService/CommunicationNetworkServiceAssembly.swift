//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import FirebaseFirestore

final class CommunicationNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommunicationNetworkServiceProtocol.self) { r in
            CommunicationNetworkService(networkService: Firestore.firestore())
        }
    }
}
