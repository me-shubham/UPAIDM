//
//  AddAccountViewController.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 22/10/21.
//

import UIKit
import DropDown
import Toaster
import SwiftSpinner

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var buttonAlert: UIButton!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewCurrencyType: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textFieldCurrencyType: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    
    let dropDown = DropDown()
    var selectedItem : [String : String]?
    var user : User!
    var wallet : Wallet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        buttonAlert.layer.cornerRadius = 15
        buttonAlert.clipsToBounds = true
        
        viewCurrencyType.layer.cornerRadius = 8
        viewCurrencyType.clipsToBounds = true
        viewCurrencyType.layer.borderWidth = 1.0
        viewCurrencyType.layer.borderColor = UIColor(named: "app_black_color")?.cgColor
        
        labelCurrencyType.text = "USD"
        selectedItem = ibanNumberDictionary["USD"]
        if let iban = selectedItem?["iban"], iban != ""{
            labelFirst.text = "IBAN: " + iban
        }else {
            labelFirst.text = ""
        }
        
        if let bic_code = selectedItem?["bic_code"], bic_code != ""{
            labelSecond.text = "BIC Code: " + bic_code
        }else {
            labelSecond.text = ""
        }
        dropDown.anchorView = labelCurrencyType // UIView or UIBarButtonItem
        dropDown.dataSource = ["USD", "GBP", "EUR", "CHF"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelCurrencyType.text = item
            selectedItem = ibanNumberDictionary[item]
            if let iban = selectedItem?["iban"], iban != ""{
                labelFirst.text = "IBAN: " + iban
            }else {
                labelFirst.text = ""
            }
            
            if let bic_code = selectedItem?["bic_code"], bic_code != ""{
                labelSecond.text = "BIC Code: " + bic_code
            }else {
                labelSecond.text = ""
            }
        }
        
        let onTapFirstLabel = UITapGestureRecognizer(target: self, action: #selector(self.onTapFirstLabel(_:)))
        labelFirst.isUserInteractionEnabled = true
        labelFirst.addGestureRecognizer(onTapFirstLabel)
        
        let onTapSecondLabel = UITapGestureRecognizer(target: self, action: #selector(self.onTapSecondLabel(_:)))
        labelSecond.isUserInteractionEnabled = true
        labelSecond.addGestureRecognizer(onTapSecondLabel)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onTapFirstLabel(_ sender: UITapGestureRecognizer? = nil) {
        if let iban = selectedItem?["iban"], iban != ""{
            UIPasteboard.general.string = iban
            Toast(text: "Copy to Clipboard", duration: Delay.short).show()
        }
    }
    
    @objc func onTapSecondLabel(_ sender: UITapGestureRecognizer? = nil) {
        if let bic_code = selectedItem?["bic_code"], bic_code != ""{
            UIPasteboard.general.string = bic_code
            Toast(text: "Copy to Clipboard", duration: Delay.short).show()
        }
    }
    
    @IBAction func onClickProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileVC", sender: self)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCurrencyType(_ sender: UIButton) {
        if(dropDown.isHidden){
            dropDown.show()
        }else {
            dropDown.hide()
        }
    }
    
    @IBAction func onClickOkay(_ sender: Any) {
        if(textFieldAmount.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter amount."), animated: true, completion: nil)
            return
        }
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                return
            }
            SwiftSpinner.show("")
            let depositTransactionRequest = DepositTransactionRequest()
            depositTransactionRequest.userId = userId
            depositTransactionRequest.amount = Double(textFieldAmount.text ?? "")
            depositTransactionRequest.iban = selectedItem?["iban"]
            depositTransactionRequest.currency = labelCurrencyType.text
            depositTransactionRequest.type = textFieldCurrencyType.text
            
            ApiManager.sharedInstance.depositRequest(data: depositTransactionRequest){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? false {
                        self.present(commonAlertWithAction(title: "Alert", message: "Deposit request added.", viewController: self), animated: true)
                    } else{
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
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
