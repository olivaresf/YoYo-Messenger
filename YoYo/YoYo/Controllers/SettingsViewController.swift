//
//  SettingsViewController.swift
//  YoYo
//
//  Created by Vishnu Divakar on 2/18/21.
//

import UIKit
import SDWebImage

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    
    private let settingsService = SettingsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileImageView.layer.cornerRadius = profileImageView.layer.bounds.height / 2
        profileImageView.clipsToBounds = true
        settingsService.delegate = self
        settingsService.fetchUserProfile()
    }
    
    @IBAction func changeNameTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Change name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "enter your new name"
        }
        let changeAction = UIAlertAction(title: "Change", style: .default) { (_) in
            let textField = alertController.textFields?.first
            let newName = textField!.text!
            if newName.count > 0 {
                self.settingsService.changeName(name: newName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func requestPasswordTapped(_ sender: Any) {
        settingsService.sendPasswordResetRequest(email: emailTextLabel.text!)
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        if !settingsService.logout() {
            presentAlert(title: "Logout", msg: "unable to logout right now. please try again later")
        }
    }
    
    private func presentAlert(title: String, msg: String) {
        let uiAlertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        uiAlertController.addAction(okAction)
        present(uiAlertController, animated: true, completion: nil)
    }
    
}

// MARK:- Service Delegate Methods
extension SettingsViewController: SettingsDelegate {
    func changeNameStatus(status: Bool, error: Error?) {
        if status {
            self.settingsService.fetchUserProfile()
        } else if let error = error {
            presentAlert(title: "Change Name Error", msg: error.localizedDescription)
        } else {
            presentAlert(title: "Change Name Error", msg: "Unable to change your name.")
        }
    }
    
    func sendPasswordResetStatus(error: Error?) {
        if let error = error {
            presentAlert(title: "Reset password", msg: error.localizedDescription)
        } else {
            presentAlert(title: "Reset password", msg: "Please follow the instructions specified in the email.")
        }
    }
    
    func fetchUserProfileSuccess(userModel: UserModel) {
        profileImageView.sd_setImage(with: URL(string: userModel.profilePictureURL), completed: nil)
        nameTextLabel.text = userModel.name
        emailTextLabel.text = userModel.userEmail
    }
    
}
