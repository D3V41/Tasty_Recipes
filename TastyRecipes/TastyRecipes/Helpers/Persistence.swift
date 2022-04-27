//
//  Persistence.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

// This is the class responsible for manipulating data in Firestore DB
class Persistence{
    
    // Adds a favorite to the logged user.
    // Favorite struct has user (logged user), category and meal.
    static func addFavorite(favorite: Favorite){
        let db = Firestore.firestore()
        
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("favorites").addDocument(data: [
            "user": favorite.user,
            "categoryId": favorite.category,
            "mealId": favorite.mealId
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //Return all favorite meals of the logged user.
    //Return a list of Favorite
    static func getFavoritesByUser(loggedUser: String, completionHandler: @escaping ([Favorite], Error?) -> Void){
        let db = Firestore.firestore()
        var favs = [Favorite]()
        
        db.collection("favorites")
            .whereField("user", isEqualTo: loggedUser)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionHandler(favs, err)
                    return
                }
                
                for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        let user = data["user"] as? String ?? ""
                        let category = data["categoryId"] as? String ?? ""
                        let mealId = data["mealId"] as? String ?? ""
                        
                        let fav = Favorite(documentId: document.documentID, user: user, category: category, mealId: mealId)
                        
                        favs.append(fav)
                        
                        print("\(document.documentID) => \(document.data())")
                }
                
                print("before completion handler")
                
                completionHandler(favs, nil)
        }
    }
    
    //Filter all favorite meals of the logged user by category.
    static func getFavoritesMealsIdByUserAndCategory(loggedUser: String, category: String, completionHandler: @escaping ([String], Error?) -> Void){
        let db = Firestore.firestore()
        var mealsId = [String]()
        
        print("category => \(category)")
        print("loggedUser => \(loggedUser)")
        
        db.collection("favorites")
            .whereField("user", isEqualTo: loggedUser)
            .whereField("categoryId", isEqualTo: category)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionHandler(mealsId, err)
                    return
                }
                
                for document in querySnapshot!.documents {
                    let mealId = document.data()["mealId"] as? String ?? ""
                    
                    mealsId.append(mealId)
                    
                    print("mealId => \(mealId)")
                }
                
                completionHandler(mealsId, nil)
        }
    }
    
    //Removes a meal from the favorite list of the logged user
    static func deleteFavoriteMealByUserIdAndMealId(loggedUSer: String, mealId: String, completionHandler: @escaping (String, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("favorites").whereField("user", isEqualTo: loggedUSer).whereField("mealId", isEqualTo: mealId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(mealId, err)
                return
            }
            
            for document in querySnapshot!.documents {
                document.reference.delete();
            }
            completionHandler(mealId, nil)
        }
    }

    
}
