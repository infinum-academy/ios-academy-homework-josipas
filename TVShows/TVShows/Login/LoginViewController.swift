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
   
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    //MARK: - Properties
    
   
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        rememberMeLabel.text = "Remember me"
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


