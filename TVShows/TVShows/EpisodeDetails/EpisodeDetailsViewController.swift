//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
