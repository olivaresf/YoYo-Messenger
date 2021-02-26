//
//  StoriesViewController.swift
//  YoYo
//
//  Created by Vishnu Divakar on 2/25/21.
//

import UIKit
import AVKit

class StoriesViewController: UIViewController {

    @IBOutlet weak var myStoryStackView: UIStackView!
    @IBOutlet weak var myStoryImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var tableStories: [Story] = []
    private let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imagePicker.delegate = self
    }
    
    private func setupView() {
        myStoryImageView.layer.borderWidth = 2.0
        myStoryImageView.layer.masksToBounds = false
        myStoryImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        myStoryImageView.layer.cornerRadius = myStoryImageView.layer.bounds.height / 2
        myStoryImageView.clipsToBounds = true
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.myStoryStackView.frame.size.height - 1, width: self.myStoryStackView.frame.size.width, height:1)
        bottomBorder.backgroundColor = UIColor.darkGray.cgColor
        myStoryStackView.layer.addSublayer(bottomBorder)
    }
    
    private func presentAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showMyStoriesTapped(_ sender: Any) {
    }
    
    @IBAction func addStoriesTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// MARK:- Image Picker Delegate Methods
extension StoriesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // TODO:- Handle media
        var videoLengthConstraintMet = true
        let mediaType = info[.mediaType]
        if mediaType != nil && mediaType as! String == "public.image" {
            print("image")
        } else if mediaType != nil && mediaType as! String == "public.movie" {
            print("movie")
            let videoURL = info[.mediaURL] as? URL
            if let videoURL = videoURL {
                let asset = AVURLAsset(url: videoURL)
                let duration = asset.duration.seconds
                if duration > 60 {
                    videoLengthConstraintMet = false
                } else {
                    // TODO:- Save video to firestore
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
        if !videoLengthConstraintMet {
            presentAlert(title: "Story uploading failed", msg: "Story should be less than 60 seconds.")
        }
    }
}