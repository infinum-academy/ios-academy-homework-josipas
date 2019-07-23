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

struct ShowEpisode: Codable{
    let id: String
    let title: String
    let description: String
    let imageUrl : String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    
    var idOfChosenShow = ""
    private var TvShow : ShowDetails?
    private var episodes : [ShowEpisode]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

private extension ShowDetailsViewController {
    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
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
                        self?.showTitle.text = details.title
                        self?.showDescription.text = details.description
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
            }
            
            SVProgressHUD.show()
            Alamofire
                .request(
                    "https://api.infinum.academy/api/shows/" + idOfChosenShow + "/episodes",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<[ShowEpisode]>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let episodes):
                        print("Succes: \(episodes)")
                        self?.episodes = episodes
                        self?.numberOfEpisodes.text = String(episodes.count)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
            }
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let episodesUnpacked = episodes else {
            return 0
        }
        return episodesUnpacked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        guard let episode = episodes else {
            return cell
        }
        cell.configure(with: episode[indexPath.row])
        return cell
    }
}
