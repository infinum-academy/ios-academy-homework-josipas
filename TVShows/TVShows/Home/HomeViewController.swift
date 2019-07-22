//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 15/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

struct TvShowItem : Codable{
    let id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var shows : [TvShowItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = shows?[indexPath.row]
        //print("Selected Item: \(item)")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let showUnpacked = shows else {
            return 0
        }
        return showUnpacked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvShowsTableViewCell", for: indexPath) as! TvShowsTableViewCell
        guard let show = shows else {
            return cell
        }
        cell.configure(with: show[indexPath.row])
        return cell
    }
}

private extension HomeViewController {
    func setupTableView() {
        let homeViewController = self as UIViewController
        navigationController?.setViewControllers([homeViewController], animated: true)
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let login = Storage.shared.loginUser {
            let headers = ["Authorization": login.token]
            SVProgressHUD.show()
            Alamofire
                .request(
                    "https://api.infinum.academy/api/shows",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<[TvShowItem]>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let shows):
                        print("Succes: \(shows)")
                        self?.shows = shows
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                    
                    self?.tableView.reloadData()
            }
        }
    }
}


