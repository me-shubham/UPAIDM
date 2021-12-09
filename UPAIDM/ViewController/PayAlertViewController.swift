//
//  PayAlertViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 01/02/21.
//

import UIKit


class PayAlertViewController: UIViewController {
    
    @IBOutlet weak var labelSentRecieveTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelToFromTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonAlert: UIButton!
    @IBOutlet weak var viewBack: UIView!
    
    
    
    var sentRecieveTitle: String?
    var amount: String?
    var toFromTitle: String?
    var date: String?
    
    var titleAlertButton = "Okay"
    var heightButton: CGFloat = 30
    var bottomButton: CGFloat = 20
    var callback : ((Int) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        
        buttonAlert.layer.cornerRadius = 15
        buttonAlert.clipsToBounds = true
        viewBack.layer.cornerRadius = 8
        viewBack.clipsToBounds = true
        
        labelSentRecieveTitle.text = sentRecieveTitle
        labelAmount.text = amount
        labelToFromTitle.text = toFromTitle
        labelDate.text = date
        buttonAlert.setTitle(titleAlertButton, for:.normal)
        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    
    @IBAction func onClickAlert(_ sender: Any) {
        callback?(1)
        self.dismiss(animated: true, completion: nil)
    }
 

}
