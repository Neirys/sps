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
    @IBOutlet private weak var changeDateLabel: UILabel!
    
    // MARK: Configuration methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idLabel.layer.masksToBounds = true
        idLabel.layer.cornerRadius = 5.0
    }
    
    func configure(with proposalChange: ProposalChangeViewModel) {
        idLabel.backgroundColor = proposalChange.cartBackgroundColor.color()
        idLabel.textColor = proposalChange.cartTextColor.color()
        idLabel.text = proposalChange.id
        
        changeDescriptionLabel.text = proposalChange.changeDescription
        changeDateLabel.text = proposalChange.changeDate
        
        nameLabel.text = proposalChange.name
        
        backgroundColor = proposalChange.cellBackgroundColor.color()
    }
}
