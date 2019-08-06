//
//  SignupViewController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/28/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    let firebaseStuff = FirebaseStuff()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding Delegates
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        //Hiding navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        //setting up image picker
        userImage.setBackgroundImage(UIImage(named: "userProfile"), for: .normal)
        userImage.layer.cornerRadius = (userImage.frame.height) / 2
        userImage.layer.borderWidth = 1.5
        userImage.layer.borderColor = UIColor.gray.cgColor
        userImage.clipsToBounds = true
        userImage.imageView?.contentMode = .scaleAspectFit
        
        //Adding Circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.width / 2,y: -10), radius: CGFloat(self.view.frame.width * 0.55), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor(red:0.25, green:0.33, blue:0.83, alpha:1.0).cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.insertSublayer(shapeLayer, at: 0)
        
        //Text field formatting
        usernameField.designed()
        emailField.designed()
        passwordField.designed()
        confirmPasswordField.designed()
        haveAnAccountLabel.adjustsFontSizeToFitWidth = true
        //Button Formatting
        signupButton.backgroundColor =  UIColor(red:0.25, green:0.33, blue:0.83, alpha:1.0)
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
        signupButton.clipsToBounds = true
        
        loginButton.contentHorizontalAlignment = .left
        
        //Listen for Keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        //Stop listening to keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillchange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + keyboardRect.height * 0.6
        } else {
            view.frame.origin.y = 0
        }
    }
    //Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.userImage.setBackgroundImage(pickedImage, for: .normal)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Changing it so text fields go to eachother
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            confirmPasswordField.becomeFirstResponder()
        case confirmPasswordField:
            textField.resignFirstResponder()
            signup()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    //Dismisses keyboard if view is tapped
    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //MARK: - Signup functions
    @IBAction func signupButton(_ sender: UIButton) {
        signup()
    }
    
    func signup(){
        guard let username = usernameField.text, username != "", let email = emailField.text, email != "", let password = passwordField.text, password != "", let confirmPassword = confirmPasswordField.text, confirmPassword != "" else {presentFeildsNotFilledOut(); return}
        if password == confirmPassword{
            firebaseStuff.signup(username: username, email: email.lowercased(), password: password) { (didComplete,error)  in
                if didComplete{
                    self.navigationController?.popViewController(animated: true)
                }
                if error != nil{
                    self.presentEmailOrPasswordAlert()
                }
            }
        } else{
            presentPasswordsDontMatchAlert()
        }
    }
}
//Alerts
extension SignupViewController: UIAlertViewDelegate{
    
    func presentEmailOrPasswordAlert() {
        let alertController = UIAlertController(title: "Error", message: "Email or Password was invalid", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Ok", style: .default) { (_) in
        }
        alertController.addAction(addAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentFeildsNotFilledOut() {
        let alertController = UIAlertController(title: "Missing Info", message: "Please fill out all fields", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Ok", style: .default) { (_) in
        }
        alertController.addAction(addAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentPasswordsDontMatchAlert() {
        let alertController = UIAlertController(title: "Miss typed Password", message: "Passwords did not match", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Ok", style: .default) { (_) in
        }
        alertController.addAction(addAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
