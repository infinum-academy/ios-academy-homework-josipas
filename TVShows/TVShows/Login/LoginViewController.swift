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
   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var registerUser: User?
    private var isCheckBoxSelected = false
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "isCheckBoxSelected") {
            guard let username = defaults.object(forKey: Keys.username) as? String, let password = defaults.object(forKey: Keys.password) as? String
            else { return }
        self._loginUserWith(email: username, password: password)
        }

        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        
        loginButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction private func checkboxTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            isCheckBoxSelected = true
        } else {
            isCheckBoxSelected = false
        }
    }

    @IBAction private func loginButtonPressed() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return }
       _loginUserWith(email: username, password: password)
    }
    
    @IBAction private func createButtonPressed() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        if !(username.isEmpty) && !(password.isEmpty) {
            _registerUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
        } else {
            let alert = UIAlertController(title: "Incomplete form", message: "Please fill out all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    if (self?.isCheckBoxSelected)! {
                        self?.saveDataToUserDefaults(username: email, password: password)
                    }
                    self?.registerUser = User(email: user.email, type: user.type, id: user.id)
                    self?.navigateToHome()
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<LoginData>) in
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let login):
                    print("Success: \(login)")
                    if (self?.isCheckBoxSelected)! {
                        self?.saveDataToUserDefaults(username: email, password: password)
                    }
                    Storage.shared.loginUser = LoginData(token: login.token)
                    self?.navigateToHome()
                case .failure(let error):
                    print("API failure: \(error)")
                    DispatchQueue.main.async {
                        self?.loginFailed()
                    }
                }
        }
    }
    
    private func navigateToHome() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func saveDataToUserDefaults(username: String, password: String) {
        defaults.set(username, forKey: Keys.username)
        defaults.set(password, forKey: Keys.password)
        defaults.set(true, forKey: Keys.isCheckBoxSelected)
    }
    
    private func loginFailed() {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 2
        self.passwordTextField.layer.add(pulseAnimation, forKey: "animateOpacity")
        self.usernameTextField.layer.add(pulseAnimation, forKey: "animateOpacity")
    }
}
