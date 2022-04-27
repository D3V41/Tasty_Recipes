//
//  SearchViewController.swift
//  SearchTabbar
//
//  Created by Deval Italiya on 3/22/22.
//

import UIKit
import FirebaseAuth

//Search field for users to search any meal and table view for showing search result to logged in user.
class SearchViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    //seatinng up table view
    //setting height of table view cell and registering it
    //geting three random meals as top recipes
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSearchResults.delegate = self
        self.tableSearchResults.dataSource = self
        
        
        tableSearchResults.rowHeight = 70.0
        
        tableSearchResults.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        getRandomMeals()
        
        
    }
    
    //setting navigation title
    //and setting up search text by adding some properties
    //reloding table view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "Search"
        
        inputSearch.clearButtonMode = .whileEditing
        
        let searchImage:UIImageView = UIImageView(image: UIImage(named: "search24"))
        searchImage.tintColor = UIColor.darkGray
        
               
        inputSearch.leftView = searchImage
        inputSearch.leftViewMode = UITextField.ViewMode.always


        inputSearch.leftView?.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        inputSearch.leftView?.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        
        tableSearchResults.reloadData()
        


    }
    
    
    //for getting number of rows from search array and if it is empty then adding one cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchArray.isEmpty{
            return 1
        } else{
        return searchArray.count
        }
    }
    
    //for show data of search array in table view
    // and if search array is empty then showing the custom cell with title "no results.."
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchArray.isEmpty{
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            tableSearchResults.isScrollEnabled = false
            cell.textLabel?.text = "No Results...."
            cell.textLabel?.textColor = UIColor.gray
            print("No Results....")
            return cell
        }else{
        let cell = tableSearchResults.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            cell.selectionStyle = .gray
        tableSearchResults.isScrollEnabled = true
        cell.imageDish.layer.cornerRadius = 5.0
            
        cell.imageDish.loadFrom(URLAddress: searchArray[indexPath.row].strMealThumb ?? "https://www.themealdb.com/images/media/meals/u55lbp1585564013.jpg")

        cell.labelDishCategory.text = searchArray[indexPath.row].strCategory
            
        cell.labelDishName.text = searchArray[indexPath.row].strMeal
        
        return cell
        }
    }
    
    // setting header of table view if search text box is empty then title will be 'Top recipe'
    //      otherwise it will be 'Results'
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerV = UIView()
        headerV.backgroundColor = UIColor.clear
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.backgroundColor  = UIColor.white
        if inputSearch.text == "" {
            label.text = "  Top Recipes"
        } else{
            label.text = "  Results"
        }
        headerV.addSubview(label)
        return headerV
        
        
    }
    
    // which ever row selected getting data of that row and sending to recipeviewcontroller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeVC = RecipeViewController()
        
        recipeVC.mealRecipe = searchArray[indexPath.row]
        
        recipeVC.loggedUser = (Auth.auth().currentUser?.uid)!
        navigationController?.pushViewController(recipeVC, animated: true)
        return
    }
    
    // it will get three random meals from meals api
    func getRandomMeals() {
        searchArray = []
        for _ in 1...3{
            Requests.randomMeal { results in
                self.searchArray.append(contentsOf: results)
                DispatchQueue.main.async {
                    self.tableSearchResults.reloadData()
                }
            }
        }
    }
    
    // it will get meals which is searched by the user from api
    func getSearchMeals(name:String) {
        searchArray = []
        Requests.getSearchResult(name: name, completionHandler: { (results) in
            self.searchArray.append(contentsOf: results)
            DispatchQueue.main.async {
                self.tableSearchResults.reloadData()
            }
        })
    }
    
    //getting text from searchbox using while editting function
    @IBAction func searchChanged(_ sender: Any) {
        if inputSearch.text == "" {
            getRandomMeals()
        } else {
            getSearchMeals(name: inputSearch.text ?? "a")
        }
    }
    
    var searchArray = [DetailedMeal]()
    
    @IBOutlet weak var inputSearch: UITextField!
    
    @IBOutlet weak var tableSearchResults: UITableView!
    
    
}

// image view extension for geting image from the image url 
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
