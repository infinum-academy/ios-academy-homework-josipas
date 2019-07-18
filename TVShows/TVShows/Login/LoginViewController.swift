//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 07/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
   
    //MARK: - Outlets
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Properties
    
    private var registerUser: User?
    private var loginUser: LoginData?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    //MARK: - Actions
    @IBAction private func checkboxTouched(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

    @IBAction private func navigateToHomeLoginButton() {
        _loginUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func navigateToHomeCreateButton() {
        if !(usernameTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty) {
            _registerUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    
   @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
    
    private func _registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    self.registerUser = User(email: user.email, type: user.type, id: user.id)
                    /*DispatchQueue.main.async {
                        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                        self.navigationController?.pushViewController(HomeViewController, animated: true)
                    }*/
                case .failure(let error):
                    print("API failure: \(error)")
                }
            }
        }
    
    private func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<LoginData>) in
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let login):
                    print("Success: \(login)")
                    self.loginUser = LoginData(token: login.token)
                    DispatchQueue.main.async {
                        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                        self.navigationController?.pushViewController(HomeViewController, animated: true)
                    }
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
   
}
