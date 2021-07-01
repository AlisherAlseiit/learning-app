//
//  UserService.swift
//  LearningApp
//
//  Created by Алишер Алсейт on 26.06.2021.
//

import Foundation

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
