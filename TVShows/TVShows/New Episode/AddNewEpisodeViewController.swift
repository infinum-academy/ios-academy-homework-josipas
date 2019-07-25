//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class AddNewEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add episode"
        setUpUI()
    }
    
    @objc func didSelectAddShow() {
        // "Add show" API call
        print("Add")
    }
    
    @objc func didSelectCancel() {
        // "Add show" API call
        print("Cancel")
    }
}

private extension AddNewEpisodeViewController {
    func setUpUI() {
            let navigationBar = navigationController?.navigationBar
            navigationBar?.barTintColor = .white
            navigationBar?.isTranslucent = false
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.tintColor = UIColor(red:1.00, green:0.46, blue:0.55, alpha:1.0)
        
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Add",
                style: .plain,
                target: self,
                action: #selector(didSelectAddShow)
            )
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Cancel",
                style: .plain,
                target: self,
                action: #selector(didSelectCancel)
            )
    }
}
    



