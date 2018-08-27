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
            self.ccTokenField.textField.returnKeyType = .default
            self.ccTokenField.textField.autocapitalizationType = .none
            self.ccTokenField.normalTokenAttributes = tokenAttributes
            self.ccTokenField.highlightedTokenAttributes = tokenAttributes
            self.ccTokenField.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
