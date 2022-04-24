//
//  ProfileInfoInteractor.swift
//  
//
//  Created by Арман Чархчян on 14.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileInfoInteractorInput: AnyObject {
    
}

protocol ProfileInfoInteractorOutput: AnyObject {
    
}

final class ProfileInfoInteractor {
    
    weak var output: ProfileInfoInteractorOutput?
}

extension ProfileInfoInteractor: ProfileInfoInteractorInput {
    
}
