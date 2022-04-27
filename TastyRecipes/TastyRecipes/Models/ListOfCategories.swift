//
//  ListOfCategories.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-25.
//

import Foundation

// Used as return of category APIs
struct ListOfCategories:Codable{
    public let categories:[Category]
}
