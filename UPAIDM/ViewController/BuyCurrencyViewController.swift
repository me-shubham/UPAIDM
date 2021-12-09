//
//  BuyCurrencyViewController.swift
//  UPAIDM
//
//  Created by shubham singh on 26/11/21.
//

import UIKit
import DropDown
import SwiftSpinner


class BuyCurrencyViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var baseAmountTextField: UITextField!
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var convertedCurencyLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buyRequestButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
    
    var user : User!
    let dropDown = DropDown()
    var wallet : Wallet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        amountTextField.delegate = self
        self.targetAmountLabel.text = "MSC1"
        self.baseCurrencyLabel.text = "EUR"
        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        
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
        
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrency.text = currencyType
            let walletAmount = Double(currencyAmount)
            self.labelAmount.text = "\(walletAmount?.rounded(toPlaces: 2) ?? 0.0)"
            
        }
        
        buyRequestButton.layer.cornerRadius = 25
        buyRequestButton.clipsToBounds = true
        convertButton.layer.cornerRadius = 22
        convertButton.clipsToBounds = true
        amountTextField.addTarget(self, action: #selector(handleBaseAmountTextField), for: .editingChanged)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    
    @IBAction func convertTapped(_ sender: Any) {
        
        if amountTextField.text == "" {
            
            self.present(commonAlert(title: "Alert", message: "Please enter Target Amount."), animated: true, completion: nil)
            
            return
            
        }
        
        convertCurrency()
        
    }
    
    @objc private func handleBaseAmountTextField() {
        
        if amountTextField.text != "" {
            
            convertCurrency()
            
        } else{
            
            self.baseAmountTextField.text = nil
            
        }
        
        
    }
    
    private func convertCurrency() {
        
        
        let targetAmount = Double(self.amountTextField.text ?? "0.0") ?? 0.0
        
        
        if self.targetAmountLabel.text == "XLM" {
            
            convertXLM(baseCurrency: self.baseCurrencyLabel.text ?? "", targetAmount: targetAmount)
            
        } else {
            
            
            convertMSC1(baseCurrency: self.baseCurrencyLabel.text ?? "", targetAmount: targetAmount)
        }
        
        
    }
    
    
    private func convertXLM(baseCurrency: String, targetAmount: Double) {
        
        CryptoHelper().getXLMCurrentValue(baseCurrency: baseCurrency) { (error, currentValue) in
            
            if error != nil {
                
                self.present(commonAlert(title: "Alert", message: error?.localizedDescription ?? "Something went wrong."), animated: true, completion: nil)
                
                return
                
            }
            
            DispatchQueue.main.async {
                
                let currentAmount = currentValue ?? 0.0
                
                let convertedAmount = targetAmount * currentAmount
                self.convertedCurencyLabel.text = "Current Rate: 1 XLM is \(currentAmount.rounded(toPlaces: 2)) \(baseCurrency)"
                self.baseAmountTextField.text = "\(convertedAmount.rounded(toPlaces: 2))"
                
            }
            
            
        }
        
        
    }
    
    private func convertMSC1(baseCurrency: String, targetAmount: Double) {
        
        let currentAmount = CryptoHelper().getMSC1CurrentValue(baseCurrency: baseCurrency)
        let convertedAmount = targetAmount * currentAmount
        self.convertedCurencyLabel.text = "Current Rate: 1 MSC1 is \(currentAmount.rounded(toPlaces: 2)) \(baseCurrency)"
        self.baseAmountTextField.text = "\(convertedAmount.rounded(toPlaces: 2))"
    
    }
    
    
    @IBAction func buyRequestTapped(_ sender: Any) {
        
        if amountTextField.text == "" {
            
            self.present(commonAlert(title: "Alert", message: "Please enter Target Amount."), animated: true, completion: nil)
            
            return
            
        }
        
        if baseAmountTextField.text == "" {
            
            self.present(commonAlert(title: "Alert", message: "Please enter Target Amount."), animated: true, completion: nil)
            
            return
            
        }
       
        if !checkAccountBalance(selectedCurrency: self.baseCurrencyLabel.text ?? "") {
            
            self.present(commonAlert(title: "Alert", message: "You don't have enough funds available in your wallet to process this request."), animated: true, completion: nil)
            
            return
            
        }
        
        if passwordTextField.text == "" {
            
            self.present(commonAlert(title: "Alert", message: "Please verify your password."), animated: true, completion: nil)
            
            return
            
        }
        
        
        if Reachability()?.connection == Reachability.Connection.none{
            
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
            
        } else {
            
            SwiftSpinner.show("")
            
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else {
                
                self.goToLogin()
                
                return
            }
            
            ApiManager.sharedInstance.sessionByUserId(userId: userId){ [self] (response) in
                
                if let response = response {
                    
                    if response.status ?? false {
                        
                        var targetCurrency = self.targetAmountLabel.text ?? ""
                        
                        if targetCurrency == "MSC1" {
                            
                            targetCurrency = "msc1"
                            
                        }
                        
                        
                        let request = CryptoTransactionRequest()
                        request.baseAmount = Double(self.baseAmountTextField.text ?? "0.0") ?? 0.0
                        request.baseCurrency = self.baseCurrencyLabel.text ?? ""
                        request.password = self.passwordTextField.text ?? ""
                        request.targetAmount = Double(self.amountTextField.text ?? "0.0") ?? 0.0
                        request.targetCurrency = targetCurrency
                        request.walletId = self.wallet?._id ?? ""
                        
                        CryptoHelper().requestCryptoTransaction(transactionType: .buy, request: request) { (apiResponse) in
                            
                            SwiftSpinner.hide()
                            
                            if apiResponse?.status == true {
                                
                                DispatchQueue.main.async {
                                   
                                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.cryptoTransactionSuccess.rawValue), object: nil)
                                    
                                    self.present(commonAlertWithActionBack(title: "Success", message: apiResponse?.msg ?? "Buy Request sent successfully.", viewController: self), animated: true, completion: nil)
                                    
                                }
                               
                                return
                                
                            } else {
                                
                                
                                DispatchQueue.main.async {
                                
                                    self.present(commonAlert(title: "Alert", message: apiResponse?.msg ?? "Something went wrong."), animated: true, completion: nil)
                                    
                                }
                                
                                return
                            }
                            
                            
                        }
                        
                        
                    } else {
                        
                        SwiftSpinner.hide()
                        self.goToLogin()
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                        
                        return
                    }
                    
                } else {
                    
                    SwiftSpinner.hide()
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func dropDownTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if(dropDown.isHidden){
            dropDown.show()
        }else {
            dropDown.hide()
        }
    }
    
    @IBAction func targetDropDownTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let dropDown = DropDown()
        
        dropDown.bottomOffset = CGPoint(x: 0, y: targetAmountLabel.frame.height + 10)
        dropDown.anchorView = targetAmountLabel // UIView or UIBarButtonItem
        dropDown.dataSource = ["MSC1", "XLM"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.targetAmountLabel.text = item
            
            if self.amountTextField.text != "" {
                
                self.convertCurrency()
                
            }
            
        }
        
        
    }
    
    
    @IBAction func baseDropDownTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let dropDown = DropDown()
        
        dropDown.bottomOffset = CGPoint(x: 0, y: baseCurrencyLabel.frame.height + 10)
        dropDown.anchorView = baseCurrencyLabel // UIView or UIBarButtonItem
        dropDown.dataSource = ["EUR", "USD", "GBP", "CHF"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.baseCurrencyLabel.text = item
            
            if self.amountTextField.text != "" {
                
                self.convertCurrency()
                
            }
        
        }
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        
        
    }
    
    private func checkAccountBalance(selectedCurrency: String) -> Bool {
        
        if selectedCurrency == "EUR" {
            
            let userBalance =  self.wallet?.EUR ?? 0.0
            let baseAmount = Double(self.baseAmountTextField.text ?? "0.0") ?? 0.0
            
            if userBalance < baseAmount {
                
                print("Balance is low unable to purchase")
                
                return false
                
            }
            
        }
        
        if selectedCurrency == "USD" {
            
            let userBalance =  self.wallet?.USD ?? 0.0
            let baseAmount = Double(self.baseAmountTextField.text ?? "0.0") ?? 0.0
            
            if userBalance < baseAmount {
                
                print("Balance is low unable to purchase")
                
                return false
                
            }
            
            
        }
        
        if selectedCurrency == "GBP" {
            
            let userBalance =  self.wallet?.GBP ?? 0.0
            let baseAmount = Double(self.baseAmountTextField.text ?? "0.0") ?? 0.0
            
            if userBalance < baseAmount {
                
                print("Balance is low unable to purchase")
                
                return false
                
            }
            
            
        }
        
        if selectedCurrency == "CHF" {
            
            let userBalance =  self.wallet?.CHF ?? 0.0
            let baseAmount = Double(self.baseAmountTextField.text ?? "0.0") ?? 0.0
            
            if userBalance < baseAmount {
                
                print("Balance is low unable to purchase")
                
                return false
                
            }
            
            
        }
        
        print("Ready to purchase")
        
        return true
    }
 
    
}
