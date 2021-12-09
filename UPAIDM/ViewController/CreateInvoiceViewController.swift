//
//  CreateInvoiceViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 26/11/20.
//

import UIKit
import SwiftSpinner
import CoreNFC
import DropDown

class CreateInvoiceViewController: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate {
    
    @IBOutlet weak var businessNameTextField: NeumorphismTextField!
    @IBOutlet weak var reasonNameTextField: NeumorphismTextField!
    @IBOutlet weak var dateTextField: NeumorphismTextField!
    @IBOutlet weak var amountTextField: NeumorphismTextField!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
   
    var wallet : Wallet?
    let dropDown = DropDown()
    
    var nfcSession: NFCNDEFReaderSession?
    var user : User!
    var invoice : Invoice!
    let transactionRequest = CreateInvoiceRequest()
    var currencyName : String = "EUR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        amountTextField.delegate = self
        dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrencyType.text = currencyType
            self.labelAmount.text = currencyAmount
        }
    }
    
    func bindData() {
        
        labelCurrencyType.text = "€"
        labelAmount.text = "\(self.wallet?.EUR ?? 0.0)"

        dropDown.anchorView = labelCurrencyType // UIView or UIBarButtonItem
        dropDown.dataSource = ["€", "$", "£", "Fr"]
        dropDown.backgroundColor = UIColor(named: "app_background_color")
        dropDown.selectionBackgroundColor = UIColor(named: "app_background_color") ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectedTextColor = UIColor(named: "app_blue_color") ?? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelCurrencyType.text = item
            switch index {
            case 0:
                self.labelAmount.text = "\(self.wallet?.EUR ?? 0.0)"
                self.currencyName = "EUR"
            case 1:
                self.labelAmount.text = "\(self.wallet?.USD ?? 0.0)"
                self.currencyName = "USD"
            case 2:
                self.labelAmount.text = "\(self.wallet?.GBP ?? 0.0)"
                self.currencyName = "GBP"
            case 3:
                self.labelAmount.text = "\(self.wallet?.CHF ?? 0.0)"
                self.currencyName = "CHF"
            default:
                self.labelAmount.text = "0.0"
                self.currencyName = "EUR"
            }
            userDefaults.set(self.labelCurrencyType.text, forKey: UDKeys.currencyType)
            userDefaults.set(self.labelAmount.text, forKey: UDKeys.currencyAmount)
            userDefaults.synchronize()
        }
        
        if let image = UIImage(named: "date-1"){
            dateTextField.withImage(image: image)
        }
        if let image = UIImage(named: "amount"){
            amountTextField.withImage(image: image)
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "yyyy-M-d"
            self.dateTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateTextField.resignFirstResponder() // 2-5
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
    
    @IBAction func onClickSend(_ sender: NeumorphismButton) {
        
        if(businessNameTextField.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter business name."), animated: true, completion: nil)
            return
        }else if(reasonNameTextField.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter service or product."), animated: true, completion: nil)
            return
        }else if(dateTextField.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter date."), animated: true, completion: nil)
            return
        }else if(amountTextField.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter amount."), animated: true, completion: nil)
            return
        }
        
        if Reachability()?.connection == Reachability.Connection.none {
            
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            
            self.performSegue(withIdentifier: "ScanOption", sender: self)
            

        }
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        
        // 1
        guard tags.count == 1 else {
            session.invalidate(errorMessage: "Can not write to more than one tag.")
            return
        }
        let currentTag = tags.first!

        // 2
        session.connect(to: currentTag) { error in

            guard error == nil else {
                session.invalidate(errorMessage: "Could not connect to tag.")
                return
            }

            // 3
            currentTag.queryNDEFStatus { status, capacity, error in

                guard error == nil else {
                    session.invalidate(errorMessage: "Could not query status of tag.")
                    return
                }

                switch status {
                case .notSupported: session.invalidate(errorMessage: "Tag is not supported.")
                case .readOnly:     session.invalidate(errorMessage: "Tag is only readable.")
                case .readWrite:
                    var payloadData = Data() // 0x02 + 'en' = Locale Specifier
                    payloadData.append("\(self.invoice._id ?? "")".data(using: .utf8)!)

                    let payload = NFCNDEFPayload.init(
                        format: NFCTypeNameFormat.nfcWellKnown,
                        type: "T".data(using: .utf8)!,
                        identifier: Data(),
                        payload: payloadData,
                        chunkSize: 0)


                                   let myMessage = NFCNDEFMessage.init(records: [payload])

                    currentTag.writeNDEF(myMessage) { (myMessage) in
                                       if let error = error {
                                           session.alertMessage = "Write NDEF message fail: \(error)"
                                       }
                                       else {
                                           session.alertMessage = "Write NDEF message successful!"
                                        DispatchQueue.main.async() {
                                        self.navigationController?.popToRootViewController(animated: true)
                                        }
                                        
                                       }

                                       session.invalidate()
                                   }
                @unknown default:   session.invalidate(errorMessage: "Unknown status of tag.")
                }
            }
        }
    }
    

    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
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
        
        if(segue.identifier == "QRCode"){
            if let viewController = segue.destination as? QRCodeGenratorViewController {
                viewController.invoice = self.invoice
            }
        }
        
        if(segue.identifier == "ScanOption"){
            if let viewControllerB = segue.destination as? ScanOptionAlertViewController {
                viewControllerB.callback = {[self] tag in
                    //Do what you want in here!
                    if(tag == 1){
                        viewControllerB.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "SelectUser", sender: self)
                    }else if(tag == 2){
                        
                        viewControllerB.dismiss(animated: true, completion: nil)
                        SwiftSpinner.show("")
                        transactionRequest.sender = user._id
                        transactionRequest.business = businessNameTextField.text
                        transactionRequest.reason = reasonNameTextField.text
                        transactionRequest.date = dateTextField.text
                        transactionRequest.type = "fiat"
                        transactionRequest.amount = Double(amountTextField.text ?? "")
                        transactionRequest.currency = currencyName
                       
                        ApiManager.sharedInstance.createInvoice(data: transactionRequest){ [self] (response) in
                            SwiftSpinner.hide()
                            if response?.status ?? false {
                                self.invoice = response?.invoice
                                DispatchQueue.main.async() {
                                    self.nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
                                    self.nfcSession?.alertMessage = "Tap your NFC tag on mobile to write."
                                    self.nfcSession?.begin()
                                    }
                            }else{
                                self.present(commonAlert(title: "Alert", message: response?.msg ?? "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                    }else if(tag == 3){
                        viewControllerB.dismiss(animated: true, completion: nil)
                        
                        SwiftSpinner.show("")
                        transactionRequest.sender = user._id
                        transactionRequest.business = businessNameTextField.text
                        transactionRequest.reason = reasonNameTextField.text
                        transactionRequest.date = dateTextField.text
                        transactionRequest.type = "fiat"
                        transactionRequest.amount = Double(amountTextField.text ?? "")
                        transactionRequest.currency = currencyName
                        
                        ApiManager.sharedInstance.createInvoice(data: transactionRequest){ [self] (response) in
                            SwiftSpinner.hide()
                            if response?.status ?? false {
                                self.invoice = response?.invoice
                                self.performSegue(withIdentifier: "QRCode", sender: self)
                            }else{
                                self.present(commonAlert(title: "Alert", message: response?.msg ?? "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                        
                    } else if(tag == 4){
                    
                        viewControllerB.dismiss(animated: true, completion: nil)
                        
                        SwiftSpinner.show("")
                        transactionRequest.sender = user._id
                        transactionRequest.business = businessNameTextField.text
                        transactionRequest.reason = reasonNameTextField.text
                        transactionRequest.date = dateTextField.text
                        transactionRequest.type = "fiat"
                        transactionRequest.amount = Double(amountTextField.text ?? "")
                        transactionRequest.currency = currencyName
                        
                        ApiManager.sharedInstance.createInvoice(data: transactionRequest){ [self] (response) in
                            SwiftSpinner.hide()
                            if response?.status ?? false {
                                self.invoice = response?.invoice
                                self.present(commonAlertWithAction(title: "Alert", message: "Invoice generated successfully.", viewController:self), animated: true, completion: nil)
                            }else{
                                self.present(commonAlert(title: "Alert", message: response?.msg ?? "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                    }else{
                        viewControllerB.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        if(segue.identifier == "SelectUser"){
            if let viewControllerB = segue.destination as? SelectUserViewController {
                viewControllerB.users = [User]()
                viewControllerB.callback = { [self] payeeUser in
                    if(user == nil){
                    viewControllerB.dismiss(animated: true, completion: nil)
                    self.present(commonAlert(title: "Alert", message: "No nearby user exists who genrate an invoice."), animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                        SwiftSpinner.show("")
                        transactionRequest.sender = user._id
                        transactionRequest.business = businessNameTextField.text
                        transactionRequest.reason = reasonNameTextField.text
                        transactionRequest.date = dateTextField.text
                        transactionRequest.type = "fiat"
                        transactionRequest.amount = Double(amountTextField.text ?? "")
                        transactionRequest.currency = currencyName
                        transactionRequest.receiver = payeeUser?._id
                        
                        ApiManager.sharedInstance.createInvoice(data: transactionRequest){ [self] (response) in
                            SwiftSpinner.hide()
                            if response?.status ?? false {
                                self.invoice = response?.invoice
                                self.present(commonAlertWithAction(title: "Alert", message: "Invoice generated successfully.", viewController:self), animated: true, completion: nil)
                            }else{
                                self.present(commonAlert(title: "Alert", message: response?.msg ?? "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
   

}

