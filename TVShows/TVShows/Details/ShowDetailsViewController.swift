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

final class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    
    var idOfChosenShow = ""
    private var TvShow : ShowDetails?
    private var episodes : [ShowEpisode] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.fixTableHeaderViewHeight()
    }
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped() {
        navigateToAddNewEpisode()
    }
    
}

private extension ShowDetailsViewController {
    func setUpUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        getShowDetails()
        getEpisodes()
    }
    
    func navigateToAddNewEpisode() {
        let addNewEpisodeStoryboard = UIStoryboard(name: "AddNewEpisode", bundle: nil)
        let addNewEpisodeViewController = addNewEpisodeStoryboard.instantiateViewController(withIdentifier: "AddNewEpisodeViewController")
        if let addNewEpisode = addNewEpisodeViewController as? AddNewEpisodeViewController {
            addNewEpisode.showId = idOfChosenShow
            addNewEpisode.delegate = self
        }
        let naavigationController = UINavigationController(rootViewController: addNewEpisodeViewController)
        self.navigationController?.present(naavigationController, animated: true)
    }
    
    func getShowDetails() {
        if let login = Storage.shared.loginUser {
            print(login.token)
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
                        let url = URL(string: "https://api.infinum.academy\(details.imageUrl)")
                        self?.image.kf.setImage(with: url)
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
            }
        }
    }
    
    func getEpisodes() {
        if let login = Storage.shared.loginUser {
            SVProgressHUD.show()
            let headers = ["Authorization": login.token]
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
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        cell.configure(with: episodes[indexPath.row])
        return cell
    }
}

extension ShowDetailsViewController : AddNewEpisodeDelegate {
    func reloadEpisodes() {
        getEpisodes()
    }
}

extension UITableView {
    
    func fixTableHeaderViewHeight(for size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)) {
        guard let headerView = tableHeaderView else { return }
        let headerSize: CGSize
        if #available(iOS 10.0, *) {
            headerSize = headerView.systemLayoutSizeFitting(size)
        } else {
            headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        if headerView.bounds.height == headerSize.height { return }
        headerView.bounds.size.height = headerSize.height
        headerView.layoutIfNeeded()
        tableHeaderView = headerView
    }
    
    func fixTableFooterViewHeight(for size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)) {
        guard let footerView = tableFooterView else { return }
        let footerSize: CGSize
        if #available(iOS 10.0, *) {
            footerSize = footerView.systemLayoutSizeFitting(size)
        } else {
            footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        if footerView.bounds.height == footerSize.height { return }
        footerView.bounds.size.height = footerSize.height
        footerView.layoutIfNeeded()
        tableFooterView = footerView
    }
    
}
