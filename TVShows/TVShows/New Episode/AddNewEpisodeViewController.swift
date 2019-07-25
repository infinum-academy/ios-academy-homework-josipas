//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

protocol AddNewEpisodeDelegate: class {
    func reloadEpisodes()
}

class AddNewEpisodeViewController: UIViewController {
    
    @IBOutlet weak var episodeTitleField: UITextField!
    @IBOutlet weak var seasonField: UITextField!
    @IBOutlet weak var episodeNumberField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var showId = ""
    weak var delegate: AddNewEpisodeDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add episode"
        setUpUI()
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
                action: #selector(didSelectAdd)
            )
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Cancel",
                style: .plain,
                target: self,
                action: #selector(didSelectCancel)
            )
    }
    
    @objc func didSelectAdd() {
        if let login = Storage.shared.loginUser {
            SVProgressHUD.show()
            let headers = ["Authorization": login.token]
            let parameters: [String: String] = [
                "showId": showId,
                "mediaId": "",
                "title": episodeTitleField.text!,
                "description" : descriptionField.text!,
                "episodeNumber" : episodeNumberField.text!,
                "season" : seasonField.text!
            ]
            Alamofire
                .request(
                    "https://api.infinum.academy/api/episodes",
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseData { response in
                        SVProgressHUD.dismiss()
                        switch response.result {
                        case .success(let episode):
                            print("Succes: \(episode)")
                            self.delegate?.reloadEpisodes()
                            self.presentingViewController?.dismiss(animated: true, completion:nil)
                        case .failure(let error):
                            print("API failure: \(error)")
                }
            }
        }
    }
    
    @objc func didSelectCancel() {
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
}
    



