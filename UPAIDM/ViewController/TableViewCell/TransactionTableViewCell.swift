//
//  TransactionTableViewCell.swift
//  u-paid-m
//
//  Created by Srajansinghal on 26/11/20.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelAmmount: UILabel!
    @IBOutlet weak var labelStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelAmmount.adjustsFontSizeToFitWidth = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
