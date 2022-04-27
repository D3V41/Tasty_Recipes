//
//  FavoriteMealsCollectionViewController.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-04-10.
//

import UIKit

private let reuseIdentifier = "FavoriteMealCollectionViewCell"

// This is the collection view that displays all the favorite meals
//   according to the category chosen in the FavoritesViewController
class FavoriteMealsCollectionViewController: UICollectionViewController {
    
    let defaultMealImage: String = "https://www.themealdb.com/images/category/beef.png"
    
    var meals: [DetailedMeal] = []
    var category: String = ""
    var loggedUser: String = ""
    
    //Set the background to white (on xcode12 it was appearing black)
    //If the category or logged user is not filled, the view is dismissed
    //Loads all the favorites meals to show
    //Set the title on top of the page
    //Register cell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.white

        if(category == "" || loggedUser == ""){
            dismiss(animated: true, completion: nil)
        }
        
        getFavoritesByCategory()
        
        //title at the top of the page
        navigationItem.title = "Favorite Meals"

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FavoriteMealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //Sets the FlowLayout of the view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.itemSize = CGSize(width: 200, height: 200)
                }
    }

    //Define one unique section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //Define that all the items will be inside one single section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    //Configure the cell, filling the image and title of it accordingly to the object in the array
    //Set the layout of the image to have rounded corners
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteMealCollectionViewCell
    
        let mealTitle = meals[indexPath.row].strMeal
        let imageURL = meals[indexPath.row].strMealThumb
        
        cell.mealTitleLabel.text = mealTitle
        cell.mealImage.loadFrom(URLAddress: imageURL ?? defaultMealImage)
        cell.mealImage.layer.cornerRadius = 20
        cell.mealImage.clipsToBounds = true
    
        return cell
    }
    
    //Set the mininum spacing for section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    //Set the minimum spacing between items
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    //Set the insets for each element
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    //When a cell is clicked, the Recipe View Controller is displayed
    //The cell informs the view which meal should be loaded.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //open the meal page
        let recipeVC = RecipeViewController()
        recipeVC.mealRecipe = meals[indexPath.row]
        recipeVC.loggedUser = self.loggedUser
        navigationController?.pushViewController(recipeVC, animated: true)
    }
    
    //Retrieves all the meals that will be shown in the view.
    //  Filters all the favorite meals of the logged user by category
    func getFavoritesByCategory(){
        Persistence.getFavoritesMealsIdByUserAndCategory(loggedUser: self.loggedUser, category: self.category, completionHandler: { (mealsId, error) in
          
            for mealId in mealsId{
                Requests.getMealById(id: mealId, completionHandler:{ results in
                    
                    self.meals.append(contentsOf: results)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        })
    }
    
}
