//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 31/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD
import Kingfisher

final class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var episodeTitle: UILabel!
    @IBOutlet private weak var episodeSeason: UILabel!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var episodeDescription: UITextView!

    
    var episodeId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getEpisodeDetails()
    }
    
    @IBAction private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func commentButtonTapped() {
        navigateToComments()
    }
}

private extension EpisodeDetailsViewController {
    func getEpisodeDetails() {
        guard let login = Storage.shared.loginUser else { return }
        SVProgressHUD.show()
        let headers = ["Authorization": login.token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/\(episodeId)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<ShowEpisode>) in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let episode):
                    print("Succes: \(episode)")
                    self.episodeTitle.text = episode.title
                    self.episodeSeason.text = "S\(episode.season) E\(episode.episodeNumber)"
                    self.episodeDescription.text = episode.description
                    if !(episode.imageUrl.isEmpty)  {
                        self.emptyView.isHidden = true
                        let url = episode.imageURL
                        self.imageView.kf.setImage(with: url)
                    } else { self.imageView.isHidden = true }
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    func navigateToComments() {
        let commentsStoryboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsViewController = commentsStoryboard.instantiateViewController(withIdentifier: "CommentsViewController")
        let naavigationController = UINavigationController(rootViewController: commentsViewController)
        if let comments = commentsViewController as? CommentsViewController {
            comments.episodeId = episodeId
            navigationController?.present(naavigationController, animated: true)
        }
    }
}


