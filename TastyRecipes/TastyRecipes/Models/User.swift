//
//  User.swift
//  TastyRecipes
//
//  Created by user204824 on 3/30/22.
//

import Foundation

//Represents a User stored in Firebase
struct User:Codable{
    public let userName: String?
    public let email: String?
    public let password: String?
}
