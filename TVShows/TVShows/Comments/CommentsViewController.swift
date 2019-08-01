//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class CommentsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        setUpUI()
    }
}

private extension CommentsViewController {
    func setUpUI() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        
        let backItem = UIBarButtonItem.init(
            image: UIImage(named: "ic-navigate-back"),
            style: .plain,
            target: self,
            action: #selector(navigateToEpisodeDetails))
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func navigateToEpisodeDetails() {
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
}
