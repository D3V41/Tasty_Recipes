//
//  ViewController.swift
//  SearchTabbar
//
//  Created by Deval Italiya on 3/22/22.
//

import UIKit
import FirebaseAuth

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)

        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 1)
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "starIcon"), tag: 2)
        
        let accountVC = UINavigationController(rootViewController: AccountViewController())
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "person"), tag: 3)
        
        viewControllers = [homeVC, searchVC, favoritesVC, accountVC]
    }
    
    
    // check if user is logged out or not.
    // if user is logged in they should directly redirected to main view(skip login)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = Auth.auth().currentUser {
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)

        }
        
    }
}

