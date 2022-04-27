//
//  ListOfResumedMeals.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-25.
//

import Foundation

//Used as return of Meal APIs
struct ListOfSimpleMeals:Codable{
    public let meals:[SimpleMeal]
}
