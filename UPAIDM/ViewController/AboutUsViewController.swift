//
//  AboutUsViewController.swift
//  UPAIDM
//
//  Created by shubham singh on 24/11/21.
//

import UIKit
import SwiftGifOrigin

class AboutUsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileButton: NeumorphismButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutUsButton: NeumorphismButton!
    @IBOutlet weak var helpSupportButton: NeumorphismButton!
    @IBOutlet weak var homeButton: NeumorphismButton!
    @IBOutlet weak var termsButton: NeumorphismButton!
    @IBOutlet weak var cryptoWalletButton: NeumorphismButton!
    
    var user : User!
    
    let aboutUsArray = ["We sell the products and services we develop primarily through partnerships around the globe", "Our focus revovles around solutions to business problems. These include B2B transactions, credit transfer, operations, payment systems etc.", "SN2 is the inventor of the 2DVVI techno-methodology(see The AI Book Ch 32) and groundbreaking technologies like u-paid-m liquid"]
    
    let aboutUsIcon: [UIImage] = [#imageLiteral(resourceName: "Vector-1"), #imageLiteral(resourceName: "Vector"), #imageLiteral(resourceName: "Vector-2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        if let userName = userDefaults.string(forKey: UDKeys.userFullName) {
        
            self.welcomeLabel.text = "Hey, \(userName)"
            
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.9
        paragraphStyle.alignment = .justified
        
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.paragraphSpacing = 15
        paragraphStyle1.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: "About Us\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .medium), NSAttributedString.Key.paragraphStyle: paragraphStyle1])
        
        attributedString.append(NSMutableAttributedString(string: "We are active from 2008. It was created by seasoned entrepreneurs with expertise in Business Transformation, Supply Chain Management, DLT and Learning Systems", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: .regular), NSAttributedString.Key.paragraphStyle: paragraphStyle]))
        
        titleLabel.attributedText = attributedString
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        aboutUsButton.cornerRadius = 8
        helpSupportButton.cornerRadius = 8
        homeButton.cornerRadius = 8
        termsButton.cornerRadius = 8
        cryptoWalletButton.cornerRadius = 8
        
    }
   
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func buttonInfoTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func buttonHomeTapped(_ sender: Any) {
        
        self.goToHome()
        
    }
    
    @IBAction func buttonTermsAndConditionTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "TermsAndConditionsViewController", animation: false)
        
        
    }
    
    @IBAction func cryptoWalletTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "CyptoTabViewController", animation: false)
        
    }
    
    @IBAction func helpAndSupportTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "HelpAndSupportViewController", animation: false)
        
    }
    
   
    
}


extension AboutUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aboutUsArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? AboutUsViewCell
        
        cell?.aboutUsLabel.text = aboutUsArray[indexPath.item]
        cell?.aboutUsLabel.numberOfLines = 0
        cell?.iconImageView.image = aboutUsIcon[indexPath.item]
        
        return cell ?? UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    
    
}
