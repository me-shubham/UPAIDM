//
//  AlertViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 26/11/20.
//

import UIKit


class AlertViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var labelTitle: NeumorphismLabel!
    @IBOutlet weak var labelMessage: NeumorphismLabel!
    @IBOutlet weak var buttonAlert: NeumorphismButton!
    
    @IBOutlet weak var buttonAlertHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonAlertBottomContraint: NSLayoutConstraint!
    
    
    

    var titleAlert: String?
    var messageAlert: String?
    var titleAlertButton = "Okay"
    var heightButton: CGFloat = 30
    var bottomButton: CGFloat = 20
    var callback : ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        backView.layer.cornerRadius = 16
        backView.clipsToBounds = true
        labelTitle.text = titleAlert
        labelMessage.text = messageAlert
        buttonAlert.setTitle(titleAlertButton, for:.normal)
        buttonAlertBottomContraint.constant = bottomButton
        buttonAlertHeightContraint.constant = heightButton
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickAlert(_ sender: Any) {
        callback?(1)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
