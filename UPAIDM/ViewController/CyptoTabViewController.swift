//
//  CyptoTabViewController.swift
//  UPAIDM
//
//  Created by shubham singh on 26/11/21.
//

import UIKit
import DropDown
import SwiftSpinner

class CyptoTabViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileButton: NeumorphismButton!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var buyCurrencyView: NeumorphismView!
    @IBOutlet weak var sellCurrencyView: NeumorphismView!
    @IBOutlet weak var cryptoButton: NeumorphismButton!
    
    var user : User!
    let dropDown = DropDown()
    var wallet : Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        if let userName = userDefaults.string(forKey: UDKeys.userFullName) {
        
            self.welcomeLabel.text = "Hey, \(userName)"
            
        }
        
        cryptoButton.cornerRadius = 8
        
        dropDown.bottomOffset = CGPoint(x: 0, y: labelCurrency.frame.height + 10)
        dropDown.anchorView = labelCurrency // UIView or UIBarButtonItem
        dropDown.dataSource = ["€", "$", "£", "Fr", "MSC1", "XLM"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelCurrency.text = item
            switch index {
            case 0:
                self.labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
            case 1:
                self.labelAmount.text = "\(self.wallet?.USD?.rounded(toPlaces: 2) ?? 0.0)"
            case 2:
                self.labelAmount.text = "\(self.wallet?.GBP?.rounded(toPlaces: 2) ?? 0.0)"
            case 3:
                self.labelAmount.text = "\(self.wallet?.CHF?.rounded(toPlaces: 2) ?? 0.0)"
            case 4:
                self.labelAmount.text = "\(self.wallet?.MSC1?.rounded(toPlaces: 2) ?? 0.0)"
            case 5:
                self.labelAmount.text = "\(self.wallet?.XLM?.rounded(toPlaces: 2) ?? 0.0)"
            default:
                self.labelAmount.text = "0.0"
            }
            userDefaults.set(self.labelCurrency.text, forKey: UDKeys.currencyType)
            userDefaults.set(self.labelAmount.text, forKey: UDKeys.currencyAmount)
            userDefaults.synchronize()
        }
        
        buyCurrencyView.isUserInteractionEnabled = true
        buyCurrencyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBuyCurrencyTapped)))
        
        sellCurrencyView.isUserInteractionEnabled = true
        sellCurrencyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSellCurrencyTapped)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateWallet), name: NSNotification.Name(NotificationName.cryptoTransactionSuccess.rawValue), object: nil)
        
        fetchUserData()
        
    }
    
    @objc private func handleUpdateWallet() {
        
        fetchUserData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrency.text = currencyType
            let walletAmount = Double(currencyAmount)
            self.labelAmount.text = "\(walletAmount?.rounded(toPlaces: 2) ?? 0.0)"
            
        }
        
    }
    
    
    @objc private func handleBuyCurrencyTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BuyCurrencyViewController") as! BuyCurrencyViewController
        vc.wallet = self.wallet
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc private func handleSellCurrencyTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SellCurrencyViewController") as! SellCurrencyViewController
        vc.wallet = self.wallet
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    @IBAction func dropDownButton(_ sender: Any) {
        
        if(dropDown.isHidden){
            dropDown.show()
        }else {
            dropDown.hide()
        }
        
    }
    
    @IBAction func buyCurrencyTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func sellCurrencyTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func aboutUsTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "AboutUsViewController", animation: false)
        
    }
    
    
    
    @IBAction func helpAndSupportTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "HelpAndSupportViewController", animation: false)
        
    }
    
    
    @IBAction func homeTapped(_ sender: Any) {
        
        self.goToHome()
        
    }
    
    @IBAction func termsConditionTapped(_ sender: Any) {
        
        self.moveToAnotherTab(identifier: "TermsAndConditionsViewController", animation: false)
        
    }
    
    
    
}


extension CyptoTabViewController {
    
    func fetchUserData() {
        
        if Reachability()?.connection == Reachability.Connection.none {
            
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
            
        }else{
            
            SwiftSpinner.show("")
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                self.goToLogin()
                return
            }
            
            ApiManager.sharedInstance.sessionByUserId(userId: userId){ [self] (response) in
                if let response = response{
                    if response.status ?? false {
                        ApiManager.sharedInstance.myWallets(userId: userId){ [self] (response) in
                            
                            SwiftSpinner.hide()
                            
                            if let response = response {
                               
                                if (response.wallets?.count ?? 0) > 0 {
                                    
                                    self.wallet = response.wallets?.filter{$0.usage == true}.first
                                    DispatchQueue.main.async {
                                        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType) {
                                            self.labelCurrency.text = currencyType
                                            switch currencyType {
                                            case "€":
                                                self.labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "$":
                                                self.labelAmount.text = "\(self.wallet?.USD?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "£":
                                                self.labelAmount.text = "\(self.wallet?.GBP?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "Fr":
                                                self.labelAmount.text = "\(self.wallet?.CHF?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "MSC1":
                                                self.labelAmount.text = "\(self.wallet?.MSC1?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "XLM":
                                                self.labelAmount.text = "\(self.wallet?.XLM?.rounded(toPlaces: 2) ?? 0.0)"
                                                
                                            default:
                                                self.labelAmount.text = "0.0"
                                            }
                                            
                                            userDefaults.set(self.labelCurrency.text, forKey: UDKeys.currencyType)
                                            userDefaults.set(self.labelAmount.text, forKey: UDKeys.currencyAmount)
                                            userDefaults.synchronize()
                                        } else {
                                            
                                            self.labelCurrency.text = "€"
                                            self.labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
                                        }
                                        
                                        self.becomeFirstResponder()
                                    }
                                    
                                } else {
                                    
                                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                                }
                                
                            }else{
                                
                                self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                        
                    }else{
                        
                        SwiftSpinner.hide()
                        self.goToLogin()
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else {
                    
                    SwiftSpinner.hide()
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }
    
}
