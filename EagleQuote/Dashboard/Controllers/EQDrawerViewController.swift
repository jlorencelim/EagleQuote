//
//  EQDrawerViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

enum DrawerSelectionCell: Int {
    case dashboard = 0
    case settings = 1
    case signOut = 2
}

class EQDrawerViewController: UIViewController {

    // MARK: - Constants
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    // MARK: - Contstants
    
    let drawerItems = ["Dashboard", "Settings", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(R.nib.drawerItem)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Protocol Implementations

extension EQDrawerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drawerItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.drawerItemCell, for: indexPath)!
        
        if indexPath.row == 0 {
            cell.highlightView.backgroundColor = R.color.button()
        }

        cell.titleLabel?.text = self.drawerItems[indexPath.row]
        
        return cell
    }
    
}

extension EQDrawerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.drawerItemCell, for: indexPath)!
        cell.highlightView.backgroundColor = R.color.button()
        
        self.tableView.reloadData()
        
        switch indexPath.row {
        case DrawerSelectionCell.signOut.rawValue:
            EQAPIAuthentication.logout { (response) in
                
                if let error = response!["error"] as? String {
                    // show error message
                    let alert =  UIAlertController(title: "Sign-in Attempt", message: error)
                    alert.show()
                } else {
                    // go to login
                    self.present(R.storyboard.authentication().instantiateInitialViewController()!,
                                 animated: true,
                                 completion: nil)
                }
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.drawerItemCell, for: indexPath)!
        cell.highlightView.backgroundColor = UIColor(hexString: "#1c163e")
        
        self.tableView.reloadData()
    }
    
}
