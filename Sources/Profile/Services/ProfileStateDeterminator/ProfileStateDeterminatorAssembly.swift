//
//  File.swift
//  
//
//  Created by Арман Чархчян on 12.05.2022.
//

import Foundation
import Swinject
import ModelInterfaces
import Managers

final class ProfileStateDeterminatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileStateDeterminator.self) { r in
            guard let account = r.resolve(AccountModelProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return ProfileStateDeterminator(account: account)
        }.inObjectScope(.weak)
    }
}
