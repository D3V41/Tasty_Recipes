//
//  LoginViewController.swift
//  TastyRecipes
//
//  Created by Ronak Kathiriya on 3/28/22.
//

import UIKit
import FirebaseAuth

// login class
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: Any) {
        guard let email = email.text,
                      let password = password.text else {
            return
        }	
        
        // firebase authentication method
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            if error == nil {
                strongSelf.dismiss(animated: true, completion: nil)
                } else {
                let alert = UIAlertController(title: "Incorrect Email or Password", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
        
    }
       
    // redirect to register view
    @IBAction func signupButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true, completion: nil)
        
    }
    
    
}
