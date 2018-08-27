//
//  EQQuoteTableViewCell.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQQuoteTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public Methods
    func configure(quote: EQQuote) {
        let client = quote.clients[0]
        var avatar: UIImage?
        
        if client.gender == "M" {
            if client.isChild {
                avatar = #imageLiteral(resourceName: "avatarBoy")
            } else {
                avatar = #imageLiteral(resourceName: "avatarMale")
            }
        } else if client.gender == "F" {
            if client.isChild {
                avatar = #imageLiteral(resourceName: "avatarGirl")
            } else {
                avatar = #imageLiteral(resourceName: "avatarFemale")
            }
        }
        
        self.userImageView.image = avatar
        self.nameLabel.text = client.name
        self.descriptionLabel.text = "\(client.age), \(client.gender), \(client.smokerString()), Class \(client.occupationID), \(client.employedStatus)"
        self.quoteLabel.text = "$\(client.premiums.minTotalPremium) - $\(client.premiums.maxTotalPremium)"
    }
}
