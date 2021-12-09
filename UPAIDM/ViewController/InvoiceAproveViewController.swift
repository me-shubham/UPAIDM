//
//  InvoiceAproveViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 25/11/20.
//£

import UIKit
import SwiftSpinner
import DropDown

class InvoiceAproveViewController: UIViewController {

    @IBOutlet weak var labelBusinessName: UILabel!
    @IBOutlet weak var labelReasonName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelPayAmount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    let dropDown = DropDown()
    
    @IBOutlet weak var buttonApprove: UIButton!
    var transactionId = ""
    var payeeUserId = ""
    var user : User!
    var wallet : Wallet!
    var invoice : Invoice!
    var currencyName : String = "EUR"
    
    var payAlertViewController : PayAlertViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        buttonApprove.layer.cornerRadius = 15
        buttonApprove.clipsToBounds = true
        
        labelCurrencyType.text = "€"
        labelAmount.text = "\(self.wallet.EUR ?? 0.0)"
        
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
        
        payAlertViewController = storyboard?.instantiateViewController(withIdentifier: "PayAlertViewController") as? PayAlertViewController
        
        if(transactionId != "") {
            if Reachability()?.connection == Reachability.Connection.none{
                self.present(commonAlertWithAction(title: "Alert", message: "Please check your internet connection.", viewController:self), animated: true, completion: nil)
            }else{
                SwiftSpinner.show("")
                ApiManager.sharedInstance.getInvoiceByID(invoiceId: transactionId){ [self] (response) in
                    SwiftSpinner.hide()
                    if let response = response{
                        if response.status ?? false {
                            self.invoice = response.invoice
                            self.bindData()
                        }else{
                            self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                        }
                    }else{
                        self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                    }
                }
            }
        }else {
            if Reachability()?.connection == Reachability.Connection.none{
                self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
            }else{
                var userIdForInvoice = ""
                if payeeUserId == ""{
                    guard let userId = userDefaults.string(forKey: UDKeys.userId) else {
                        return
                     }
                    userIdForInvoice = userId
                }else{
                    userIdForInvoice = payeeUserId
                }
                SwiftSpinner.show("")
                ApiManager.sharedInstance.getLatestInvoiceByUserID(userId: userIdForInvoice){ [self] (response) in
                    SwiftSpinner.hide()
                    if response?.status ?? false {
                        if let invoice = response?.invoice {
                            self.invoice = invoice
                            self.bindData()
                        }else {
                            self.present(commonAlertWithAction(title: "Alert", message: "No transaction is available, please ask the owner to resend.", viewController: self), animated: true)
                        }
                    }else{
                        self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrencyType.text = currencyType
            self.labelAmount.text = currencyAmount
        }
    }
    
    func bindData() {
        labelBusinessName.text = invoice.business
        labelReasonName.text = invoice.reason
        labelDate.text = invoice.date
        labelPayAmount.text = "\(invoice.amount ?? 0) \(invoice.currency ?? "")"
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
    
    @IBAction func onClickApprove(_ sender: UIButton) {
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                return
            }
            SwiftSpinner.show("")
            let updateRequest = InvoiceUpdateRequest()
            updateRequest.invoiceId = invoice._id
            updateRequest.updateData = ["status":"approve", "userId":userId]
            
            ApiManager.sharedInstance.updateInvoice(data: updateRequest){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? false {
                        payAlertViewController.sentRecieveTitle = "You sent"
                        
                        payAlertViewController.amount = "\(invoice?.amount ?? 0) \(currencyName)"
                        
                        let dateFormatter : DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm a"
                        let date = Date()
                        payAlertViewController.date = dateFormatter.string(from: date)
                        payAlertViewController.callback = { tag in
                            if(tag == 1){
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                        self.present(payAlertViewController, animated: true, completion: nil)
                    } else{
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func onClickReject(_ sender: UIButton) {
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                return
            }
            SwiftSpinner.show("")
            let updateRequest = InvoiceUpdateRequest()
            updateRequest.invoiceId = invoice._id
            updateRequest.updateData = ["status": "reject", "receiver": userId]
            ApiManager.sharedInstance.updateInvoice(data: updateRequest){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? false {
                        payAlertViewController.sentRecieveTitle = "You rejected"
                        
                        payAlertViewController.amount = "\(invoice?.amount ?? 0) \(currencyName)"
                        
                        let dateFormatter : DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm a"
                        let date = Date()
                        payAlertViewController.date = dateFormatter.string(from: date)
                        payAlertViewController.callback = { tag in
                            if(tag == 1){
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                        self.present(payAlertViewController, animated: true, completion: nil)
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
