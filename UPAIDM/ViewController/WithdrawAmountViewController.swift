//
//  WithdrawAmountViewController.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 17/10/21.
//

import UIKit
import SwiftSpinner
import DropDown

class WithdrawAmountViewController: UIViewController {
    
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var textFieldCurrencyType: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    var user : User!
    var usersList = [User]()
    var selctedUser : User!
    var wallet : Wallet?
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        labelCurrencyType.text = "€"
        labelAmount.text = "\(self.wallet?.EUR ?? 0.0)"

        dropDown.bottomOffset = CGPoint(x: 0, y: labelCurrencyType.frame.height + 10)
        dropDown.anchorView = labelCurrencyType // UIView or UIBarButtonItem
        dropDown.dataSource = ["€", "$", "£", "Fr", "MSC1", "XLM"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelCurrencyType.text = item
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
            userDefaults.set(self.labelCurrencyType.text, forKey: UDKeys.currencyType)
            userDefaults.set(self.labelAmount.text, forKey: UDKeys.currencyAmount)
            userDefaults.synchronize()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrencyType.text = currencyType
            self.labelAmount.text = currencyAmount
        }
    }
    
    @IBAction func onClickCurrencyType(_ sender: UIButton) {
        if(dropDown.isHidden){
            dropDown.show()
        }else {
            dropDown.hide()
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileVC", sender: self)
    }
    
    @IBAction func onClickWithdraw(_ sender: UIButton) {
        
        if(textFieldCurrencyType.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter Currency Type."), animated: true, completion: nil)
            return
        }
        if(textFieldAmount.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter amount."), animated: true, completion: nil)
            return
        }
        if(textFieldPassword.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter password."), animated: true, completion: nil)
            return
        }
        
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            if Reachability()?.connection == Reachability.Connection.none{
                self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
            }else{
                SwiftSpinner.show("")
                let withdrawTransactionRequest = WithdrawTransactionRequest()
                
                withdrawTransactionRequest.walletId = wallet?._id
                withdrawTransactionRequest.password = textFieldPassword.text
                withdrawTransactionRequest.amount = Double(textFieldAmount.text ?? "")
                switch labelCurrencyType.text {
                case "€":
                    withdrawTransactionRequest.currency = "EUR"
                case "$":
                    withdrawTransactionRequest.currency = "USD"
                case "£":
                    withdrawTransactionRequest.currency = "GBP"
                case "Fr":
                    withdrawTransactionRequest.currency = "CHF"
                default:
                    withdrawTransactionRequest.currency = ""
                }
                withdrawTransactionRequest.target = "iban"
                withdrawTransactionRequest.iban = ibanNumberDictionary[labelCurrencyType.text ?? ""]?["iban"]
                
                ApiManager.sharedInstance.withdrawRequest(data: withdrawTransactionRequest){ [self] (response) in
                    SwiftSpinner.hide()
                    if let response = response{
                        if response.status ?? false {
                            self.present(commonAlertWithAction(title: "Alert", message: "Successfully created withdraw request.", viewController: self), animated: true)
                        } else{
                            self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                        }
                    }else{
                        self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ProfileVC"){
            if let viewController = segue.destination as? ProfileAlertViewController {
                viewController.callback = { value in
                    switch value {
                    case 0:
                        viewController.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "ViewProfile", sender: self)
                    default:
                        viewController.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        if(segue.identifier == "ViewProfile"){
            if let viewController = segue.destination as? ProfileViewController {
                viewController.user = user
            }
        }
    }
    

}
