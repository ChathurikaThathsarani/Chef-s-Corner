//
//  RecipeTest.swift
//  Chef's CornerTests
//
//  Created by Chathurika Dombepola on 2024-04-17.
//

import XCTest
@testable import Chef_s_Corner

final class RecipeTest: XCTestCase {

    func testRecipeInitialization() {
        
            let id = "123"
            let title = "Pasta Carbonara"
            let ingredients = "Spaghetti, eggs, bacon, parmesan cheese, black pepper"
            let preparation = "1. Cook spaghetti according to package instructions. 2. Fry bacon until crispy. 3. Whisk eggs and parmesan cheese together. 4. Mix cooked spaghetti with bacon and egg mixture. 5. Serve with black pepper."
            let toCook = "10 minutes"
            let toPrep = "20 minutes"
            let special = true
            let imageUrl = URL(string: "https://example.com/pasta_carbonara.jpg")
            
            let recipe = Recipe(id: id, title: title, ingredients: ingredients, preparation: preparation, toCook: toCook, toPrep: toPrep, special: special, image: imageUrl)
            
            XCTAssertEqual(recipe.id, id)
            XCTAssertEqual(recipe.title, title)
            XCTAssertEqual(recipe.ingredients, ingredients)
            XCTAssertEqual(recipe.preparation, preparation)
            XCTAssertEqual(recipe.toCook, toCook)
            XCTAssertEqual(recipe.toPrep, toPrep)
            XCTAssertEqual(recipe.special, special)
            XCTAssertEqual(recipe.image, imageUrl)
        }
        

}
