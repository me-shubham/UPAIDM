//
//  AboutUsViewCell.swift
//  UPAIDM
//
//  Created by shubham singh on 24/11/21.
//

import UIKit

class AboutUsViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var customView: NeumorphismView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customView.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
