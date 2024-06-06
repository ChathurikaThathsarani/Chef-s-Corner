//
//  RecipeCategoryTest.swift
//  Chef's CornerTests
//
//  Created by Chathurika Dombepola on 2024-04-17.
//

import XCTest
@testable import Chef_s_Corner

final class RecipeCategoryTest: XCTestCase {

    func testRecipeCategoryInitialization() {
         
            let id = "1"
            let name = "Pasta"
            let imageUrl = URL(string: "https://example.com/pasta_category.jpg")
            
            let category = RecipeCategory(id: id, name: name, image: imageUrl)
            
            XCTAssertEqual(category.id, id)
            XCTAssertEqual(category.name, name)
            XCTAssertEqual(category.image, imageUrl)
        }

}
