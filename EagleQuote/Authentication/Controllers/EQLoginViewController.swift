//
//  EQLoginViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

import SwifterSwift


class EQLoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func onSignInButtonPressed(_ sender: UIButton) {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        if email == "" {
            // check if email field has value
            let alert =  UIAlertController(title: "Email required", message: "Please enter your email.")
            alert.show()
        } else if !EQUtils.isValidEmail(email) {
            // ckeck if email is valid
            let alert =  UIAlertController(title: "Email not valid", message: "Please check the email that you entered.")
            alert.show()
        } else if password == "" {
            // check if passwrod field has value
            let alert =  UIAlertController(title: "Password required", message: "Please enter a password.")
            alert.show()
        } else {
            // show alert
            let alert = EQUtils.loadingAlert()
            alert.show()
            
            EQAPIAuthentication.login(email: email, password: password) { (response) in
                alert.dismiss(animated: true, completion: {
                    if let error = response!["error"] as? String {
                        // show error message
                        let alert =  UIAlertController(title: "Sign-in Attempt", message: error)
                        alert.show()
                    } else {
                        // go to dashboard
                        self.present(R.storyboard.home().instantiateInitialViewController()!, animated:true, completion:nil)
                    }
                })
                
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EQLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
