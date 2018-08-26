//
//  EQDrawerViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQDrawerViewController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

