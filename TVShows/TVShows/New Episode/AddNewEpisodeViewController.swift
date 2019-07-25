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

struct Episode: Codable{
    let showId: String
    let mediaId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case mediaId
        case title
        case description
        case episodeNumber
        case season
    }
}

class AddNewEpisodeViewController: UIViewController {
    
    @IBOutlet weak var episodeTitleField: UITextField!
    @IBOutlet weak var seasonField: UITextField!
    @IBOutlet weak var episodeNumberField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var showId = ""
   
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
    



