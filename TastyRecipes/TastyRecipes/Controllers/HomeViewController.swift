//
//  HomeViewController.swift
//  TastyRecipes
//
//  Created by Faiyazuddin Mohammed on 3/29/22.
//
import Foundation
import UIKit

//This is a Table view that displays all the meal categories of the logged in user.
class HomeViewController: UITableViewController {
        
    //Default image set if the respective category image is unable to load from api
    let defaultCategoryImage: String = "https://www.themealdb.com/images/category/beef.png"
    var categories: [Category] = []
    
    //In this viewDidLoad() function, I'm calling getCategories() function located at the last part of this class, setting row height to 88 and setting navigation title and finally registering the categories table view cell.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
        
        tableView.rowHeight = 88
        
        //title at the top of the page
        navigationItem.title = "Categories"
        
       tableView.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
        
    }

    //In this function, the cell for row at is set by setting cell for each category using dequeue reusable cell and then setting image, label and description for each category cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        
        let imageURL = categories[indexPath.row].strCategoryThumb
        categoryCell.categoryNameLabel.text = categories[indexPath.row].strCategory
        categoryCell.categoryDescriptionLabel.text = categories[indexPath.row].strCategoryDescription
        categoryCell.categoryImageView.loadFrom(URLAddress: imageURL ?? defaultCategoryImage)
        
        return categoryCell
    }
    
    //This function sets the number of rows by returning the total number of categories or count of all the categories.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //Whenever a category row is selected, it should open meals table view controller for that particular category which is done in this function.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row].strCategory
        
        let MealsVC = MealsTableViewController()
        
        MealsVC.category = category ?? ""
        
        navigationController?.pushViewController(MealsVC, animated: true)
    }

    //This function gets all the categories by invoking the get all categories function in the helper file Requests.swift which gets all the categories available in Http api service.
    func getCategories() {
    categories = []
    
    Requests.getAllCategories(completionHandler: { (results) in
        
        self.categories.append(contentsOf: results)
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    })
    }
}
