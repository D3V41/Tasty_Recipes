//
//  Category.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-25.
//

import Foundation

//Contains all the information necessary of categories
struct Category:Codable{
    public let idCategory:String?
    public let strCategory: String?
    public let strCategoryThumb: String?
    public let strCategoryDescription: String?
}
