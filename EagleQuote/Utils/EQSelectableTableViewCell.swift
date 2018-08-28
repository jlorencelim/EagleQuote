//
//  EQSelectableTableViewCell.swift
//  EagleQuote
//
//  Created by Lorence Lim on 28/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit


class EQSelectableTableViewCell: UITableViewCell {
    
    @IBInspectable var selectionColor: UIColor = .gray {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
    }
    
}
