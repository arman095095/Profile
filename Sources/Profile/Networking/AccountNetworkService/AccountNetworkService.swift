//
//  AccountService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import Foundation
import FirebaseFirestore
import ModelInterfaces
import UIKit
import NetworkServices

protocol AccountNetworkServiceProtocol {
    func blockUser(accountID: String,
                   userID: String,
                   complition: @escaping (Result<Void,Error>) -> Void)
    func unblockUser(accountID: String,
                     userID: String, complition: @escaping (Result<Void,Error>) -> Void)
}

final class AccountNetworkService {
    
    private let networkServiceRef: Firestore

    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        networkService.settings = settings
        self.networkServiceRef = networkService
    }
}

extension AccountNetworkService: AccountNetworkServiceProtocol {
    
    public func blockUser(accountID: String,
                          userID: String,
                          complition: @escaping (Result<Void,Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            complition(.failure(ConnectionError.noInternet))
            return
        }
        usersRef.document(accountID).collection(ProfileURLComponents.Paths.blocked.rawValue).document(userID).setData([ProfileURLComponents.Parameters.id.rawValue: userID]) { error in
            if let error = error {
                complition(.failure(error))
            }
            complition(.success(()))
        }
    }
    
    public func unblockUser(accountID: String,
                            userID: String,
                            complition: @escaping (Result<Void,Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            complition(.failure(ConnectionError.noInternet))
            return
        }
        usersRef.document(accountID).collection(ProfileURLComponents.Paths.blocked.rawValue).document(userID).delete { error in
            if let error = error {
                complition(.failure(error))
                return
            }
            complition(.success(()))
        }
    }
}
