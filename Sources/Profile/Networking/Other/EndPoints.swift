//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

struct URLComponents {

    enum Paths: String {
        case users
        case waitingUsers
        case sendedRequests
        case friendIDs
    }

    enum Parameters: String {
        case userID
        case friendID
    }
}
