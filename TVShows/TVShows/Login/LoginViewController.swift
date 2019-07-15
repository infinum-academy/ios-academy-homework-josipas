//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 07/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    //MARK: - Outlets
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //MARK: - Properties
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        loginButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func checkboxTouched(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

    @IBAction func navigateToHomeLoginButton() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
    
        navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @IBAction func navigateToHomeCreateButton() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navigationController?.pushViewController(HomeViewController, animated: true)
    }
    

   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
      //  if let mojViewController = segue.destination as? HomeViewController {
        //    mojViewController.user = User(name: "Josipa")
     //   }
//
//        if segue.destination is HomeViewController {
//            let mojVi3weController = segue.destination as HomeViewController
//        }
        
    }
    
    
 


