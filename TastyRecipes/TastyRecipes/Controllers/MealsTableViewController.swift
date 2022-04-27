//
//  MealsTableViewController.swift
//  TastyRecipes
//
//  Created by Faiyazuddin Mohammed on 3/30/22.
//

import UIKit
import FirebaseAuth

//This is a Table view that displays all the meals under the selected category of the logged in user.
class MealsTableViewController: UITableViewController {
        
    //Default image set if the respective meal image is unable to load from api
    let defaultMealImage: String = "https://www.themealdb.com/images/category/beef.png"

    var meals: [SimpleMeal] = []
    var category: String = ""
    
    //In this viewDidLoad() function, I'm calling getMeals() function located at the last part of this class, setting row height to 80 and setting navigation title and finally registering the Meals table view cell.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if category == ""{
            dismiss(animated: true, completion: nil)
        }
        
        getMeals()
        
        tableView.rowHeight = 80
        
        //title at the top of the page
        navigationItem.title = "Selected Category Meals"
        
       tableView.register(UINib(nibName: "MealsTableViewCell", bundle: nil), forCellReuseIdentifier: "MealsTableViewCell")
    }

    //In this function, the cell for row at is set by setting cell for each meal under selected category using dequeue reusable cell and then setting image and label title for each meal cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "MealsTableViewCell", for: indexPath) as! MealsTableViewCell
        
        let mealTitle = meals[indexPath.row].strMeal
        let imageURL = meals[indexPath.row].strMealThumb
        
        categoryCell.mealsTitleLabel.text = mealTitle
        categoryCell.mealsImageView.loadFrom(URLAddress: imageURL ?? defaultMealImage)
        
        return categoryCell
    }

    //This function sets the number of rows by returning the total number of meals or count of all the meals under selected category.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    //Whenever a meal row is selected, it should open Recipe view controller for that particular meal which is done in this function.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open the meal page
        
        let recipeVC = RecipeViewController()
        
        recipeVC.mealId = meals[indexPath.row].idMeal!
        
        recipeVC.loggedUser = (Auth.auth().currentUser?.uid)!
        navigationController?.pushViewController(recipeVC, animated: true)
    }
    
    //This function gets all the meals under selected category by invoking the get meals by category function in the helper file Requests.swift which gets the meals list for that particular category available in Http api service.
    func getMeals() {
        meals = []
        
        Requests.getMealsByCategory(category: self.category) { results in
            self.meals.append(contentsOf: results)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
