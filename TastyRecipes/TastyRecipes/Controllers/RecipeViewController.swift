//
//  RecipeViewController.swift
//  TastyRecipes
//
//  Created by Jerrin Thomas on 4/7/22.
//

import UIKit

/**
 UI View controller for displaying recipe details.
 */
class RecipeViewController: UIViewController {
    
    var mealRecipe: DetailedMeal? = nil
    	
    var loggedUser: String = ""
    
    var isMealFavorite = false
    
    var mealCategory = ""
    
    var mealId = ""
    
    var favMeals: [DetailedMeal] = []
    
    let defaultMealImage: String = "https://www.themealdb.com/images/category/beef.png"
    
    @IBOutlet weak var recipeThumbImageView: UIImageView!
    
    @IBOutlet weak var recipeDetailLabel: UILabel!
    
    @IBOutlet weak var AddToFavButton: UIButton!
    
    /**
    Function to get the meal recipe object with all details related to the meal. Invoked upon the loading of the view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if(mealRecipe == nil) {
            getMealById()
        } else {
            mealCategory = mealRecipe?.strCategory ?? ""
            mealId = mealRecipe?.idMeal ?? ""
            
            displayRecipeDetails()
            navigationItem.title = mealRecipe?.strMeal
            
            processFavoriteButton()
        }
    }
    
    /**
     Function to display the recipe details in the UI View contoller elements such as label and image view.
     */
    func displayRecipeDetails(){
        let imageThumbURL = mealRecipe?.strMealThumb
        recipeThumbImageView.loadFrom(URLAddress: imageThumbURL ?? defaultMealImage)

        recipeDetailLabel.text = mealRecipe?.strInstructions

        recipeDetailLabel.textAlignment = .center
        recipeDetailLabel.font = UIFont.systemFont(ofSize: 14)
        recipeDetailLabel.contentMode = .scaleToFill
        recipeDetailLabel.numberOfLines = 0
    }
    
    /**
     Function to determine the state of the favorite button. If the meal is already in the favorites list, the state is changed to favorited.
     */
    func processFavoriteButton(){
        Persistence.getFavoritesMealsIdByUserAndCategory(loggedUser: self.loggedUser, category: self.mealCategory, completionHandler: { (mealsId, error) in
          
            for mealId in mealsId{
                Requests.getMealById(id: mealId, completionHandler:{ results in
                    
                    self.favMeals.append(contentsOf: results)
                    
                    DispatchQueue.main.async {
                        print(self.favMeals.count)
                        for favMeal in self.favMeals {
                            if(favMeal.idMeal == self.mealId && favMeal.strCategory == self.mealCategory){
                                self.AddToFavButton.setTitle("Favorited", for: .normal)
                                self.AddToFavButton.backgroundColor = UIColor.green
                                self.isMealFavorite = true
                            }
                        }
                    }
                })
            }
        })
    }
    
    /**
     Function to get the meal recipe details object from API if only meal id is available.
     */
    func getMealById(){
        Requests.getMealById(id: self.mealId, completionHandler:{ results in
            self.mealRecipe = results[0]
            self.mealCategory = results[0].strCategory!
            
            DispatchQueue.main.async {
                self.displayRecipeDetails()
                self.navigationItem.title = self.mealRecipe?.strMeal
                
                self.processFavoriteButton()
            }
        })
    }
    
    /**
     Function invoked upon hitting the Add to Favorite button. This function determines if the meal is to be added or removed from favorites list.
     */
    @IBAction func touchUpInsideAddToFavButton(_ sender: Any) {
        // delete favorite from FireStore
        if (isMealFavorite){
            Persistence.deleteFavoriteMealByUserIdAndMealId(loggedUSer: self.loggedUser, mealId: self.mealId) { (mealId, Error) in
                self.AddToFavButton.setTitle("Add to Favorite", for: .normal)
                self.AddToFavButton.backgroundColor = UIColor.systemBlue
                self.isMealFavorite = false
            }
        } else {
            let favorite = Favorite(documentId: nil, user: self.loggedUser, category: self.mealCategory, mealId: self.mealId)
            Persistence.addFavorite(favorite: favorite)
            self.processFavoriteButton()
        }
    }
}
