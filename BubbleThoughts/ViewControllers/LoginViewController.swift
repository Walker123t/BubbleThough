//
//  LoginViewController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/28/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let firebase = FirebaseStuff()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
        //TextFieldSetup
        emailField.designed()
        passwordField.designed()
        
        //View Gradient
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.width / 2,y: -10), radius: CGFloat(self.view.frame.width / 2 + 40), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor(red:0.21, green:0.84, blue:0.62, alpha:1.0).cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.insertSublayer(shapeLayer, at: 0)
        
        //Button Setup
        loginButton.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.62, alpha:1.0)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
        
        signupButton.contentHorizontalAlignment = .left
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            textField.resignFirstResponder()
            login()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func login(){
        guard let email = emailField.text, email != "", let password = passwordField.text, password != "" else {return}
        firebase.login(email: email.lowercased(), password: password) { (isValid) in
            if isValid{
                self.performSegue(withIdentifier: "validated", sender: nil)
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        login()
    }
}
