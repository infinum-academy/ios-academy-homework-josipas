//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 07/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Button.backgroundColor = UIColor.purple
        //Button.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    var count : Int = 0
    
    @IBOutlet weak var UILabel: UILabel!
    
    @IBOutlet weak var Button: UIButton!
    
    @IBAction func onButtonClick(_ sender: Any) {
        count+=1
        print("Click!")
        UILabel.text = String(count)
        
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
