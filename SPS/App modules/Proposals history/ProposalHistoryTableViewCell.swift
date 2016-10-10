//
//  ProposalHistoryTableViewCell.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

class ProposalHistoryTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var changeDescriptionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: Configuration methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idLabel.layer.masksToBounds = true
        idLabel.layer.cornerRadius = 5.0
    }
}
