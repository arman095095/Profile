//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import NetworkServices
import Services
import ModelInterfaces

protocol UserInfoManagerProtocol {
    func getProfile(userID: String, completion: @escaping (Result<ProfileModelProtocol, Error>) -> Void)
}

final class UserInfoManager {
    private let profileService: ProfileInfoNetworkServiceProtocol
    
    init(profileService: ProfileInfoNetworkServiceProtocol) {
        self.profileService = profileService
    }
}

extension UserInfoManager: UserInfoManagerProtocol {
    
    func getProfile(userID: String, completion: @escaping (Result<ProfileModelProtocol, Error>) -> Void) {
        profileService.getProfileInfo(userID: userID) { result in
            switch result {
            case .success(let profile):
                let profileModel = ProfileModel(profile: profile)
                completion(.success(profileModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
