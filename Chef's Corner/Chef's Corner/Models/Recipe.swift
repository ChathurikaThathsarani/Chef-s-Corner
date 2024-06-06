//
//  Recipe.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-08.
//

import Foundation

struct Recipe{
    let id, title, ingredients, preparation : String
    let toCook, toPrep: String
    let special: Bool
    let image: URL?
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = id
        dictionary["title"] = title
        dictionary["ingredients"] = ingredients
        dictionary["preparation"] = preparation
        dictionary["toCook"] = toCook
        dictionary["toPrep"] = toPrep
        dictionary["special"] = special
        dictionary["image"] = image?.absoluteString
        return dictionary
    }
}

