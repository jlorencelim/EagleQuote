//
//  EQHomeViewController.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentPage = 1
    private var quotes: [EQQuote] = []
    private var filteredQuotes: [String: [EQQuote]] = [:]
    
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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelSearchButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func onSearchButtonPressed(_ sender: UIBarButtonItem) {
        if self.filteredQuotes.count > 0 {
            self.cancelSearchButton.isHidden = false
            self.searchBarHeight.constant = 44
            self.searchBar.layoutIfNeeded()
        }
    }
    
    @IBAction func onCancelSearchButtonPressed(_ sender: UIButton) {
        self.cancelSearchButton.isHidden = true
        self.searchBarHeight.constant = 0
        self.searchBar.layoutIfNeeded()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(R.nib.quoteCell)
        self.tableView.register(R.nib.quoteSectionCell)
        
        self.loadData(search: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    private func loadData(search: String?) {
        EQAPIQuote.getQuote(page: self.currentPage, search: search) { (response) in
            if let quotes = response!["quotes"] as? [[String: Any]] {
                do {
                    for item in quotes {
                        let data = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                        let quote = try EQQuote(data: data)
                        
                        self.quotes.append(quote)
                    }
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
            
            self.filteredQuotes = Dictionary(grouping: self.quotes, by: { $0.dateString() })
            
            if self.filteredQuotes.count > 0 {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
}


extension EQHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredQuotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(self.filteredQuotes.keys)[section]
        return self.filteredQuotes[key]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteCell, for: indexPath)!
        let key = Array(self.filteredQuotes.keys)[indexPath.section]
        let quote = self.filteredQuotes[key]![indexPath.row]
        
        cell.configure(quote: quote)
        
        return cell
    }
    
}

extension EQHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteSectionCell.identifier) as! EQQuoteSectionTableViewCell
        
        cell.dateLabel.text = Array(self.filteredQuotes.keys)[section]
        
        return cell
    }
    
}

extension EQHomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.quotes = []
        self.loadData(search: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
