//
//  FavoritesViewController.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-25.
//

import Foundation
import UIKit
import FirebaseAuth

//Table view that displays all the favorite meal's categories of the logged user.
class FavoritesViewController: UITableViewController{
    
    let defaultCategoryImage: String = "https://www.themealdb.com/images/category/beef.png"
    
    var categories: [Category] = []
    var allCategories: [Category] = []
    
    var user: String = ""
    
    //Set row height to 80
    //Set the title of the page
    //Register the table view cell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        //title at the top of the page
        navigationItem.title = "Favorites Categories"
        
        tableView.register(UINib(nibName: "FavCategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavCategoriesTableViewCell")
    }
    
    //Before view appears, all the data is ready
    //Loads all the categories
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user = (Auth.auth().currentUser?.uid)!
        categories = []
        
        getAllCategories()
    }

    //Configure each cell for row, filling the eight thumb image and category title
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "FavCategoriesTableViewCell", for: indexPath) as! FavCategoriesTableViewCell
        
        let categoryName = categories[indexPath.row].strCategory
        let imageURL = categories[indexPath.row].strCategoryThumb
        
        categoryCell.categoryNameLabel.text = categoryName
        categoryCell.categoryThumbImageView.loadFrom(URLAddress: imageURL ?? defaultCategoryImage)
        
        return categoryCell
    }
    
    //Set the number os forw per section as all categories loaded
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //When a cell is selected, the collection view with all the meals corresponding to
    //  the selected category will be displayed.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row].strCategory
        
        let favMealsVC = FavoriteMealsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        favMealsVC.category = category ?? ""
        favMealsVC.loggedUser = self.user
        
        navigationController?.pushViewController(favMealsVC, animated: true)
    }
    
    //Since there's no API to retreive one Category by ID, we need to load all the categories
    //  available in the API and then filter in memory.
    func getAllCategories(){
        
        Requests.getAllCategories(completionHandler: { (results) in
            self.allCategories.append(contentsOf: results)
            
            DispatchQueue.main.async {
                if(self.allCategories.count > 1){
                    self.allCategories = self.allCategories.sorted(by: { $0.strCategory! < $1.strCategory! })
                }
                
                self.getAllFavoritesCategory()
            }
        })
    }
    
    // Retrieves all the favorites from the logged user and then uses it's categories
    //  to filter the array containing all categories
    func getAllFavoritesCategory(){
        
        Persistence.getFavoritesByUser(loggedUser: user, completionHandler: { (favs, error) in
            let sortedFavs = favs.sorted(by: { $0.category < $1.category })
            
            for fav in sortedFavs{
                let category = self.allCategories.filter {
                    $0.strCategory == fav.category
                }.first
                
                let duplicatedCategory = self.categories.filter { $0.strCategory == category?.strCategory }
                
                if(duplicatedCategory.isEmpty){
                    self.categories.append(category!)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
}

