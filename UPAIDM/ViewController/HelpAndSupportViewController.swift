//
//  HelpAndSupportViewController.swift
//  UPAIDM
//
//  Created by shubham singh on 24/11/21.
//

import UIKit



class HelpAndSupportViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var profileButton: NeumorphismButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutUsButton: NeumorphismButton!
    @IBOutlet weak var helpAndSupportButton: NeumorphismButton!
    @IBOutlet weak var homeButton: NeumorphismButton!
    @IBOutlet weak var termsAndConditionButton: NeumorphismButton!
    @IBOutlet weak var cryptoButton: NeumorphismButton!
    
    var user : User!
    
    let helpText = "The Hellenium Project and its subsidiaries (Hellenium, we or us) welcome you to our website, mobile applications and other services provided via electronic means (together referred to as Electronic Services) and appreciate your intreset in our products and services. Hellenium attaches importance to appropirate data protection. This page explains how we treat your personal data in connection with your use of our Electronic  Service (Privacy Policy). By continuing to use the Hellenium"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        if let userName = userDefaults.string(forKey: UDKeys.userFullName) {
        
            self.welcomeLabel.text = "Hey, \(userName)"
            
        }
        
        titleLabel.text = "Help & Support"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        
        aboutUsButton.cornerRadius = 8
        helpAndSupportButton.cornerRadius = 8
        homeButton.cornerRadius = 8
        termsAndConditionButton.cornerRadius = 8
        cryptoButton.cornerRadius = 8
        
    }
    

    @IBAction func aboutUsTapped(_ sender: Any) {
       
        self.moveToAnotherTab(identifier: "AboutUsViewController", animation: false)
        
    }
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        
        self.goToHome()
        
    }
    
    @IBAction func termsAndConditionTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "TermsAndConditionsViewController", animation: false)
        
    }
    
    
    @IBAction func cryptoTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "CyptoTabViewController", animation: false)
        
    }
    
    
    
}

extension HelpAndSupportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as? HelpAndSupportTableViewCell
        
        cell?.helpAndSupportLabel.text = self.helpText
        cell?.helpAndSupportLabel.numberOfLines = 0
        
        return cell ?? UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    
    
}
