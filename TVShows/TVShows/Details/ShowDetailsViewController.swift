//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 22/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

struct ShowDetails : Codable{
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
    }
}

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var idOfChosenShow = ""
    private var TvShow : ShowDetails?
   
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setUpUI()
    }

}

private extension ShowDetailsViewController {
    func setUpUI() {
        image.image = UIImage(named: "icImagePlaceholder")
        
        if let login = Storage.shared.loginUser {
            SVProgressHUD.show()
            let headers = ["Authorization": login.token]
            Alamofire
                .request(
                    "https://api.infinum.academy/api/shows/" + idOfChosenShow,
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<ShowDetails>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let details):
                        print("Succes: \(details)")
                        
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
            }
        }
    }
}
