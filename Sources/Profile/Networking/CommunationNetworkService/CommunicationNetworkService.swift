//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import FirebaseFirestore
import NetworkServices

public protocol CommunicationNetworkServiceProtocol: AnyObject {
    func send(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ())
    func accept(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ())
    func deny(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ())
}

final class CommunicationNetworkService {
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

extension CommunicationNetworkService: CommunicationNetworkServiceProtocol {

    
    public func send(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ()) {
        usersRef.document(toID).collection(URLComponents.Paths.waitingUsers.rawValue).document(fromID).setData( [URLComponents.Parameters.userID.rawValue:fromID]) { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.usersRef.document(fromID).collection(URLComponents.Paths.sendedRequests.rawValue).document(toID).setData([URLComponents.Parameters.userID.rawValue:toID]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    public func accept(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ()) {
        usersRef.document(fromID).collection(URLComponents.Paths.waitingUsers.rawValue).document(toID).delete()
        usersRef.document(toID).collection(URLComponents.Paths.sendedRequests.rawValue).document(fromID).delete()
        
        usersRef.document(fromID).collection(URLComponents.Paths.friendIDs.rawValue).document(toID).setData( [URLComponents.Parameters.friendID.rawValue: toID]) { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.usersRef.document(toID).collection(URLComponents.Paths.friendIDs.rawValue).document(fromID).setData([URLComponents.Parameters.friendID.rawValue: fromID]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    public func deny(toID: String, fromID: String, completion: @escaping (Result<Void, Error>) -> ()) {
        usersRef.document(fromID).collection(URLComponents.Paths.waitingUsers.rawValue).document(toID).delete { [weak self] error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self?.usersRef.document(toID).collection(URLComponents.Paths.sendedRequests.rawValue).document(fromID).delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
        
    }
}
