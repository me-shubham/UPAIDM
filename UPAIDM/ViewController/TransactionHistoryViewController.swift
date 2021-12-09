//
//  TransactionHistoryViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 26/11/20.
//

import UIKit
import SwiftSpinner


class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    var allTransactions = [Transaction]()
    var tableViewTransactions = [Transaction]()
    var user : User!
    var wallet : Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        buttonFilter.layer.cornerRadius = 20
        buttonFilter.clipsToBounds = true
        
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        getTransactionData()
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
                    tableViewTransactions = allTransactions
                    tableView.reloadData()
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickFilter(sender: UIButton)
    {
        self.performSegue(withIdentifier: "Filter", sender: self)
    }
    
    @IBAction func onClickProfile(_ sender: NeumorphismButton) {
        self.performSegue(withIdentifier: "ProfileVC", sender: self)
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
            cell.labelAmmount.text = "\(data.starting_balance ?? "")"
            cell.labelAmmount.textColor = UIColor(named: "app_green_color")
        }else {
            if let userId = userDefaults.string(forKey: UDKeys.userId) {
                if(data.senderId == userId) {
                    cell.labelAmmount.textColor = UIColor(named: "app_green_color")
                    cell.labelAmmount.text = "+ \(data.amount ?? 0) " + (data.currency ?? "")
                } else {
                    cell.labelAmmount.textColor = UIColor(named: "text_red_color")
                    cell.labelAmmount.text = "- \(data.amount ?? 0) " + (data.currency ?? "")
                }
            }
        }
        cell.labelStatus.text = ""
        if data.transaction_successful == 1 {
            cell.labelStatus.text = "Transaction Successful"
        } else{
            
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
                    if let userId = userDefaults.string(forKey: UDKeys.userId) {
                    if isFiat && isCRypto && isAll && isIncoming && isOutgoing {
                        self.tableViewTransactions = self.allTransactions
                    }else if !isFiat && !isCRypto && !isAll && !isIncoming && !isOutgoing{
                        self.tableViewTransactions = self.allTransactions
                    }else {
                        if isFiat && isCRypto {
                            self.tableViewTransactions = self.allTransactions
                        }else if !isFiat && !isCRypto {
                            self.tableViewTransactions = self.allTransactions
                        }else if isFiat {
                            self.tableViewTransactions = self.allTransactions.filter{$0.currencyType == "fiat"}
                        }else if isCRypto{
                            self.tableViewTransactions = self.allTransactions.filter{$0.currencyType == "crypto"}
                        }
                        if isAll{
                        }else if isIncoming && isOutgoing {
                        }else if isIncoming{
                            self.tableViewTransactions = self.tableViewTransactions.filter{$0.currencyType == "crypto" || $0.senderId == userId}
                        }else if isOutgoing{
                            self.tableViewTransactions = self.tableViewTransactions.filter{$0.currencyType != "crypto" && $0.senderId != userId}
                        }
                        
                    }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
