//
//  MyAccountViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 26/11/20.
//

import UIKit
import SwiftSpinner
import DropDown

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var buttonViewHisory: UIButton!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var viewTableBackground: NeumorphismButton!
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHisoryViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var topBottonViewHisoryViewHeightContraint: NSLayoutConstraint!
    
    var allTransactions = [Transaction]()
    var tableViewTransactions = [Transaction]()
    var user : User!
    var wallet : Wallet?
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        buttonViewHisory.clipsToBounds = true
        
        labelCurrencyType.text = "€"
        labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
        
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
        getTransactionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            self.labelCurrencyType.text = currencyType
            let walletAmount = Double(currencyAmount)
            
            self.labelAmount.text = "\(walletAmount?.rounded(toPlaces: 2) ?? 0.0)"
        }
    }
    
    func getTransactionData() {
        
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let walletId = wallet?._id else { return }
            SwiftSpinner.show("")
            ApiManager.sharedInstance.allTransactions(walletId: walletId) { [self] (response) in
                SwiftSpinner.hide()
                if response?.status ?? false {
                    allTransactions = response?.transactions ?? [Transaction]()
                    if(allTransactions.count == 0){
                        tableViewTransactions = Array(allTransactions.prefix(5))
                        tableViewHeightContraint.constant = CGFloat(70 * tableViewTransactions.count)
                        viewTableBackground.isHidden = true
                        
                    }else{
                        tableViewTransactions = Array(allTransactions.prefix(5))
                        tableViewHeightContraint.constant = CGFloat(70 * tableViewTransactions.count)
                        tableView.reloadData()
                        viewTableBackground.isHidden = false
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
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
    
    @IBAction func onClickProfile(_ sender: NeumorphismButton) {
        self.performSegue(withIdentifier: "ProfileVC", sender: self)
    }
    
    @IBAction func onClickFilter(sender: UIButton)
    {
        self.performSegue(withIdentifier: "Filter", sender: self)
    }
    
    @IBAction func onClickViewAllHistory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TransactionHistory", sender: self)
    }
    
    @IBAction func onClickAdd(_ sender: UIButton){
        self.performSegue(withIdentifier: "AddAccount", sender: self)
    }
    
    @IBAction func onClickWithdraw(_ sender: UIButton){
        self.performSegue(withIdentifier: "WithdrawAmount", sender: self)
    }
    
    @IBAction func onClickSend(_ sender: UIButton){
        self.performSegue(withIdentifier: "SendAmount", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        let data = tableViewTransactions[indexPath.row]
        cell.labelName.text = (data.currencyType ?? "") + ": " + (data.content ?? "")
        cell.labelDate.text = getDateInString(timeStamp: data.time ?? 0)
        if(data.currencyType == "crypto"){
            
            cell.labelAmmount.textColor = .black
            
            let startingBalance = Double(data.starting_balance ?? "0.0")?.rounded(toPlaces: 2)
            
            cell.labelAmmount.text = "\(startingBalance ?? 0.0)"
            
        } else {
            
            if let userId = userDefaults.string(forKey: UDKeys.userId) {
                
                if(data.senderId == userId) {
                    cell.labelAmmount.textColor = UIColor(named: "app_green_color")
                    cell.labelAmmount.text = "+ \(data.amount?.rounded(toPlaces: 2) ?? 0.0) " + (data.currency ?? "")
                } else {
                    cell.labelAmmount.textColor = UIColor(named: "text_red_color")
                    cell.labelAmmount.text = "- \(data.amount?.rounded(toPlaces: 2) ?? 0.0) " + (data.currency ?? "")
                }
            }
            
        }
        
        cell.labelStatus.text = ""
        if data.transaction_successful == 1 {
            
            cell.labelStatus.text = "Transaction Successful"
            
        } else {
            
            cell.labelStatus.text = nil
            
        }
        return cell
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
        
        if(segue.identifier == "Filter"){
            
            if let viewController = segue.destination as? FilterViewController {
                viewController.callback = { (isFiat, isCRypto, isAll, isIncoming, isOutgoing) in
                    viewController.dismiss(animated: true, completion: nil)
                    
                    print("isFiat: ", isFiat)
                    print("isCRypto: ", isCRypto)
                    print("isAll: ", isAll)
                    print("isIncoming: ", isIncoming)
                    print("isOutgoing: ", isOutgoing)
                    
                        
                    
                    if isAll {
                        
                        self.tableViewTransactions = self.allTransactions
                        
                    } else if !isFiat && !isCRypto && !isIncoming && !isOutgoing && !isAll {
                        
                        self.tableViewTransactions = self.allTransactions
                        
                    }else if isFiat && isCRypto && isIncoming && isOutgoing {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" || $0.currencyType == "crypto" })
                        
                    } else if isFiat && isIncoming && isOutgoing {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat"})
                        
                    } else if isFiat && isIncoming {
                    
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" && $0.senderId == self.user._id && $0.content != "send"})
                        
                    } else if isFiat && isOutgoing {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" && $0.senderId != self.user._id && $0.content != "send" })
                        
                    }else if isFiat && isCRypto && isIncoming {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" || $0.currencyType == "crypto" && $0.senderId == self.user._id && $0.transaction_successful == 1 })
                        
                    }else if isFiat && isCRypto && isOutgoing {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" || $0.currencyType == "crypto" && $0.senderId != self.user._id && $0.transaction_successful != 1 })
                        
                    } else if isFiat && isCRypto {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat" || $0.currencyType == "crypto"})
                        
                    } else if isFiat {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "fiat"})
                        
                    } else if isCRypto {
                        
                        self.tableViewTransactions = self.allTransactions.filter({$0.currencyType == "crypto"})
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            
        }
     
        if(segue.identifier == "TransactionHistory"){
            if let viewController = segue.destination as? TransactionHistoryViewController {
                viewController.user = user
                viewController.wallet = wallet
            }
        }
        
        if(segue.identifier == "AddAccount"){
            if let viewController = segue.destination as? AddAccountViewController {
                viewController.user = user
                viewController.wallet = wallet
            }
        }
        
        if(segue.identifier == "SendAmount"){
            if let viewController = segue.destination as? SendAmountViewController {
                viewController.user = user
                viewController.wallet = wallet
            }
        }
        if(segue.identifier == "WithdrawAmount"){
            if let viewController = segue.destination as? WithdrawAmountViewController {
                viewController.user = user
                viewController.wallet = wallet
            }
        }
        if(segue.identifier == "ViewProfile"){
            if let viewController = segue.destination as? ProfileViewController {
                viewController.user = user
            }
        }
        /*
        if(segue.identifier == "AlertView"){
            if let viewController = segue.destination as? AlertViewController {
                viewController.titleAlert = "Application Status"
                viewController.messageAlert = "Your application is under development...!"
            }
        }*/
    }
    

}
