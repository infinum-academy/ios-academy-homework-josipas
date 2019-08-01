//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class CommentsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newComment: UITextField!
    @IBOutlet private weak var emptyView: UIView!
    
    var episodeId = ""
    private var comments : [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        title = "Comments"
        setUpUI()
        getComments()
    }
    
    
    @IBAction private func postButonTapped() {
        guard let text = newComment.text else { return }
        if text.isEmpty {
            let alert = UIAlertController(title: "Your comment is empty!", message: "Please write something.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        else {
            postComment(comment: text)
        }
    }
}

private extension CommentsViewController {
    func setUpUI() {
        tableView.delegate = self 
        tableView.dataSource = self
        
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func getComments() {
        guard let login = Storage.shared.loginUser else { return }
        SVProgressHUD.show()
        let headers = ["Authorization": login.token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/\(episodeId)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<[Comment]>) in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let comments):
                    print("Succes: \(comments)")
                    self.comments = comments
                    self.chooseScreen()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    func postComment(comment: String) {
        guard let login = Storage.shared.loginUser else { return }
        let headers = ["Authorization": login.token]
        let parameters: [String: String] = [
            "text": comment,
            "episodeId" : episodeId
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/comments",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseData { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let comment):
                    print("Succes: \(comment)")
                    self.newComment.text = nil
                    self.getComments()
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failure!", message: "Can't add this comment!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
        }
    }
    
    func chooseScreen() {
        if comments.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            tableView.reloadData()
        }
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

