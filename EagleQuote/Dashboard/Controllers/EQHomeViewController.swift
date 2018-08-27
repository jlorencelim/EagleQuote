//
//  EQHomeViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQHomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var drawerBarButtonItem: UIBarButtonItem! {
        didSet {
            self.drawerBarButtonItem.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem! {
        didSet {
            self.searchBarButtonItem.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(R.nib.quoteCell)
        self.tableView.register(R.nib.quoteSectionCell)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension EQHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteCell, for: indexPath)!
        
        
        return cell
    }
    
}

extension EQHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteSectionCell.identifier)
        
        
        return cell
    }
    
}
