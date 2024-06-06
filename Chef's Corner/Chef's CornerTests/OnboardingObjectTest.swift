//
//  OnboardingObjectTest.swift
//  Chef's CornerTests
//
//  Created by Chathurika Dombepola on 2024-04-17.
//

import XCTest
@testable import Chef_s_Corner

final class OnboardingObjectTest: XCTestCase {

    func testOnboardingObjectInitialization() {
       
            let title = "Welcome"
            let description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            let image = UIImage(named: "Image")!
            
            let onboardingObject = OnboardingObject(title: title, description: description, image: image)
            
            XCTAssertEqual(onboardingObject.title, title)
            XCTAssertEqual(onboardingObject.description, description)
            XCTAssertNotNil(onboardingObject.image)
        }

}
