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
import Photos

protocol AddNewEpisodeDelegate: class {
    func reloadEpisodes()
}

final class AddNewEpisodeViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var episodeTitleField: UITextField!
    @IBOutlet private weak var seasonField: UITextField!
    @IBOutlet private weak var episodeNumberField: UITextField!
    @IBOutlet private weak var descriptionField: UITextField!
    
    var showId : String?
    weak var delegate: AddNewEpisodeDelegate?
    var imagePicker : UIImagePickerController?
    var chosenImage : UIImage?
    var imageId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        title = "Add episode"
        setUpUI()
    }
    
    @IBAction private func addPhoto() {
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                imagePicker = UIImagePickerController()
                guard let imagePicker = imagePicker else { return }
                imagePicker.delegate = self
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
        }
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
        if chosenImage != nil {
            uploadImageOnAPI()
        }
        addNewEpisode()
    }
    
    @objc func didSelectCancel() {
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
}

extension AddNewEpisodeViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.isHidden = false
        imageView.image = UIImage(cgImage: (chosenImage?.cgImage)!)
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }

    func uploadImageOnAPI() {
        guard let login = Storage.shared.loginUser else { return }
        let headers = ["Authorization": login.token]
        let imageByteData = chosenImage?.pngData()
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData!,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
            switch response.result {
            case .success(let media):
                print("DECODED: \(media)")
                self.imageId = media.id
                self.addNewEpisode()
            case .failure(let error): 
                print("FAILURE: \(error)")
            }
        }
    }
    
    func addNewEpisode() {
        guard
            let login = Storage.shared.loginUser,
            let showId = showId,
            let episodeTitle = episodeTitleField.text,
            let description = descriptionField.text,
            let episodeNumber = episodeNumberField.text,
            let season = seasonField.text
            else { return }
        
        if episodeTitle.isEmpty || episodeNumber.isEmpty || season.isEmpty {
            let alert = UIAlertController(title: "Incomplete form", message: "Please fill out all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let headers = ["Authorization": login.token]
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": imageId,
            "title": episodeTitle,
            "description" : description,
            "episodeNumber" : episodeNumber,
            "season" : season
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseData { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                switch response.result {
                case .success(let episode):
                    print("Succes: \(episode)")
                    self.delegate?.reloadEpisodes()
                    self.presentingViewController?.dismiss(animated: true, completion:nil)
                case .failure(let error):
                    print("API failure: \(error)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failure!", message: "Can't add this epizode!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
        }
    }
}
    


