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
    
    @IBOutlet private weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var touchCounterButton: UIButton!
    
    //MARK: - Properties
    
    private var numberOfClicks : Int = 0
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //touchCounterButton.backgroundColor = UIColor.purple
        //touchCounterButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func onButtonClick() {
        numberOfClicks += 1
        //print("Click!")
        counterLabel.text = String(numberOfClicks)
        
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
