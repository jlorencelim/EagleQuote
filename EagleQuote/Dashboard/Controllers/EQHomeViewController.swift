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
    private var selectedQuote: EQQuote!
    private var quotes: [EQQuote] = []
    private var filteredQuotes: [String: [EQQuote]] = [:]
    private var totalQuotes = 0
    private var isLoading = true
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
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
        
        self.quotes = []
        self.loadData(search: nil)
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = R.segue.eqHomeViewController.sendEmail.identifier
        
        switch segue.identifier {
        case identifier?:
            let controller = segue.destination as! EQSendEmailViewController
            
            controller.quote = self.selectedQuote
        default:
            return
        }
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
            
            self.loadingView.height = 0
            self.loadingView.isHidden = true
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
        let key = Array(self.filteredQuotes.keys)[section]
        return self.filteredQuotes[key]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.quoteCell, for: indexPath)!
        let key = Array(self.filteredQuotes.keys)[indexPath.section]
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
        
        if self.quotes.count > 0 &&
            self.quotes.count != self.totalQuotes &&
            !self.isLoading &&
            offsetY > 0 &&
            offsetY > contentHeight - scrollView.frame.size.height {
            
            self.currentPage += 1
            self.loadingView.height = 80
            self.loadingView.isHidden = false
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
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let actionSheet = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            
            actionSheet.addAction(title: "Send Quote by Email", style: .default, isEnabled: true) { (alert: UIAlertAction!) in
                self.selectedQuote = quote
                self.performSegue(withIdentifier: R.segue.eqHomeViewController.sendEmail, sender: self)
            }
            actionSheet.addAction(title: "Cancel", style: .cancel, isEnabled: true, handler: nil)
            
            topController.present(actionSheet, animated: true, completion: nil)
        }
        
    }
}
