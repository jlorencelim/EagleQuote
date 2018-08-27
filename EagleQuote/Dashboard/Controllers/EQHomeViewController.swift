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
    private var totalQuotes = 0
    private var isLoading = true
    
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
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        
        self.loadData(search: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(R.nib.quoteCell)
        self.tableView.register(R.nib.quoteSectionCell)
        self.tableView.register(R.nib.loadingCell)
        
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
            
            if let paging = response!["paging"] as? [String: Any] {
                self.totalQuotes = paging["records"] as! Int
            }
            
            self.filteredQuotes = Dictionary(grouping: self.quotes, by: { $0.dateString() })
            if self.filteredQuotes.count > 0 {
                self.tableView.isHidden = false
            }
            
            self.isLoading = false
            self.tableView.reloadData()
        }
    }
}


extension EQHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredQuotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(self.filteredQuotes.keys)
        let key = keys[section]
        return self.isLoading ? self.filteredQuotes[keys[keys.count - 1]]!.count + 1 : self.filteredQuotes[key]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keys = Array(self.filteredQuotes.keys)
        let key = keys[indexPath.section]
        
        // show loading indicator
        if self.isLoading && indexPath.section == keys.count - 1 && indexPath.row == self.filteredQuotes[key]!.count {
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loadingCell, for: indexPath)!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteCell, for: indexPath)!
        let quote = self.filteredQuotes[key]![indexPath.row]
        
        cell.delegate = self
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if self.quotes.count > 0 && self.quotes.count != self.totalQuotes && !self.isLoading && offsetY > contentHeight - scrollView.frame.size.height {
            self.currentPage += 1
            self.isLoading = true
            self.tableView.reloadData()
            
            self.loadData(search: self.searchBar.text)
        }
    }
    
}

extension EQHomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        self.quotes = []
        self.loadData(search: searchBar.text)
    }
    
}

extension EQHomeViewController: EQQuoteTableViewCellDelegate {
    
    func showActionSheet(_ controller: EQQuoteTableViewCell, quote: EQQuote) {
        let actionSheet = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(title: "Send Quote by Email", style: .default, isEnabled: true) { (alert: UIAlertAction!) in
            // TODO: navigate to send mail
        }
        actionSheet.addAction(title: "Cancel", style: .cancel, isEnabled: true, handler: nil)
        
        actionSheet.show()
        
    }
}
