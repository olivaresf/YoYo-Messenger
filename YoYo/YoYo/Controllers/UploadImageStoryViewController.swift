//
//  UploadImageStoryViewController.swift
//  YoYo
//
//  Created by Vishnu Divakar on 2/26/21.
//

import UIKit

class UploadImageStoryViewController: UIViewController {

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet var baseView: UIView!
    
    var assetData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputStackView.layer.cornerRadius = 5.0
        setupView()
        addKeyboardObserverMethods()
        
        if let assetData = assetData {
            storyImageView.image = UIImage(data: assetData)
        }
    }
    
    private func setupView() {
        titleTextField.layer.borderWidth = 1.5
        titleTextField.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.textColor = .black
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        titleTextField.clipsToBounds = true
        titleTextField.delegate = self
        
        uploadButton.layer.cornerRadius = 5.0
        uploadButton.clipsToBounds = true
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
    }
    
    private func addKeyboardObserverMethods() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
            }
        baseView.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        baseView.frame.origin.y = 0
        inputStackView.layoutMargins.bottom = 8
    }
    
}

// MARK:- UITextFieldDelegate
extension UploadImageStoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
