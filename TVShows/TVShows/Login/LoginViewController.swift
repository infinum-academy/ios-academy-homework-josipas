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
    
    // MARK: - Navigation

    @IBAction func navigateToHome() {
        let loginStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        let HomeViewController = loginStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
    
        navigationController?.pushViewController(HomeViewController, animated: true)
        
    }
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    //}
    
    
 
}

