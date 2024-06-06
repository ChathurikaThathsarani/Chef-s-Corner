//
//  User.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-03.
//

import Foundation

struct User {
    let name: String
    let email: String
    let admin: Bool
    let userId: String
    
    init(name: String, email: String, admin: Bool, userId: String) {
        self.name = name
        self.email = email
        self.admin = admin
        self.userId = userId
    }
}
