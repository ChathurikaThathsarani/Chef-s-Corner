//
//  UserTest.swift
//  Chef's CornerTests
//
//  Created by Chathurika Dombepola on 2024-04-17.
//

import XCTest
@testable import Chef_s_Corner

final class UserTest: XCTestCase {

    func testUserInitialization() {
            let name = "John Doe"
            let email = "john@example.com"
            let admin = true
            let userId = "123456"
            
            let user = User(name: name, email: email, admin: admin, userId: userId)
            
            XCTAssertEqual(user.name, name)
            XCTAssertEqual(user.email, email)
            XCTAssertEqual(user.admin, admin)
            XCTAssertEqual(user.userId, userId)
        }

}
