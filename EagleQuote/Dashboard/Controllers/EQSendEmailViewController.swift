//
//  EQSendEmailViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 27/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

import ICInputAccessory


class EQSendEmailViewController: UIViewController {
    
    // MARK: - Properties
    
    var quote: EQQuote!
    
    // MARK: - Outlets
    
    @IBOutlet weak var toTokenField: ICTokenField! {
        didSet {
            let tokenAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.backgroundColor: UIColor(hexString: "#f6f6f6")!
            ]
            self.toTokenField.textField.autocorrectionType = .no
            self.toTokenField.textField.returnKeyType = .default
            self.toTokenField.textField.autocapitalizationType = .none
            self.toTokenField.normalTokenAttributes = tokenAttributes
            self.toTokenField.highlightedTokenAttributes = tokenAttributes
            self.toTokenField.delegate = self
        }
    }
    @IBOutlet weak var ccTokenField: ICTokenField! {
        didSet {
            let tokenAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.backgroundColor: UIColor(hexString: "#f6f6f6")!
            ]
            self.ccTokenField.textField.autocorrectionType = .no
            self.ccTokenField.textField.returnKeyType = .default
            self.ccTokenField.textField.autocapitalizationType = .none
            self.ccTokenField.normalTokenAttributes = tokenAttributes
            self.ccTokenField.highlightedTokenAttributes = tokenAttributes
            self.ccTokenField.delegate = self
        }
    }
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    // MARK: - Actions
    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func onSendButtonPressed(_ sender: UIBarButtonItem) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if self.toTokenField.texts.count == 0 && self.ccTokenField.texts.count == 0 {
                let alert =  UIAlertController(title: "Recipients required", message: "Please add at least one email to send to.")
                topController.present(alert, animated: true, completion: nil)
            } else {
                let alert = EQUtils.loadingAlert()
                topController.present(alert, animated: true, completion: nil)
                
                EQAPIQuote.sendEmail(quoteId: self.quote.quoteID,
                                     to: self.toTokenField.texts,
                                     cc: self.ccTokenField.texts,
                                     subject: self.subjectTextField.text!,
                                     body: self.bodyTextView.text!) { (response) in
                    alert.dismiss(animated: true, completion: {
                        if response!["status"] as! String == "Success" {
                            self.navigationController?.popViewController()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    private func initializeFields() {
        let client = self.quote.clients[0]
        
        self.subjectTextField.text = "Insurance Quote for \(client.name)"
        self.bodyTextView.text = "Your insurance quote is attached.\n\nKind regards\n\(client.name)"
    }

}


extension EQSendEmailViewController: ICTokenFieldDelegate {
    
    func tokenField(_ tokenField: ICTokenField, subsequentDelimiterForCompletedText text: String) -> String {
        return " "
    }
    
    func tokenField(_ tokenField: ICTokenField, shouldCompleteText text: String) -> Bool {
        return EQUtils.isValidEmail(text)
    }
}
