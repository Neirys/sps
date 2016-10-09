//
//  ProposalsTableViewCell.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 09/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

class ProposalsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: Configuration methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idLabel.layer.masksToBounds = true
        idLabel.layer.cornerRadius = 5.0
    }
    
    // I know, MVC blabla but it's a specific cell (`ProposalsTableViewCell`) and I binding a VIEW model so I guess it's OK
    func configure(with proposal: ProposalViewModel) {
        idLabel.backgroundColor = proposal.cartBackgroundColor.color()
        idLabel.textColor = proposal.cartTextColor.color()
        idLabel.text = proposal.id
        
        nameLabel.text = proposal.name
    }
}
