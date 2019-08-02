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

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var shows : [TvShowItem] = []
    var showId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            self.showId = shows[indexPath.row].id
            navigateToDetails()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvShowsTableViewCell", for: indexPath) as! TvShowsTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

private extension HomeViewController {
    func setupTableView() {
        let homeViewController = self as UIViewController
        navigationController?.setViewControllers([homeViewController], animated: true)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        getTvShowItem()
    }
    
    func getTvShowItem() {
        guard let login = Storage.shared.loginUser else { return }
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
        }
    }
    
    func setUpNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.tintColor = UIColor.black
        
        let logoutItem = UIBarButtonItem.init(
            image: UIImage(named: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(_logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
        self.navigationItem.title = "Shows"
    }
    
    func navigateToDetails() {
        let showDetailsStoryboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = showDetailsStoryboard.instantiateViewController(withIdentifier: "ShowDetailsViewContoller")
        if let showDetails = showDetailsViewController as? ShowDetailsViewController {
            showDetails.idOfChosenShow = showId
            self.navigationController?.pushViewController(showDetailsViewController, animated: true)
        }
    }
    
    @objc private func _logoutActionHandler() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        if let login = loginViewController as? LoginViewController {
            login.defaults.removeObject(forKey: Keys.isCheckBoxSelected)
            login.defaults.removeObject(forKey: Keys.password)
            login.defaults.removeObject(forKey: Keys.username)
            self.navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
}


