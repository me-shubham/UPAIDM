//
//  SelectUserViewController.swift
//  u-paid-m
//
//  Created by Srajansinghal on 04/12/20.
//

import UIKit
import SwiftSpinner

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var viewNoNearByDevices: UIView!
    @IBOutlet weak var buttonTryAgain: UIButton!
    
    var callback : ((User?) -> Void)?
    var users = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        backView?.layer.cornerRadius = 16
        backView?.clipsToBounds = true
        viewPopup?.layer.cornerRadius = 16
        viewPopup?.clipsToBounds = true
        buttonTryAgain?.layer.cornerRadius = 15
        buttonTryAgain?.clipsToBounds = true
        
        if(users.count == 0){
            viewNoNearByDevices.isHidden = false
            tableView.isHidden = true
        }else{
            viewNoNearByDevices.isHidden = true
            tableView.isHidden = false
        }
        if(users.count > 0){
            if(self.users.count == 0){
                viewNoNearByDevices.isHidden = false
                self.tableView.isHidden = true
            }else {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                viewNoNearByDevices.isHidden = true
            }
        }else {
            getUserList()
        }
    }
    
    func getUserList() {
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else {
                return
             }
            SwiftSpinner.show("")
            ApiManager.sharedInstance.getNearByUsers(userId: userId){ [self] (response) in
                SwiftSpinner.hide()
                if response?.status ?? false {
                    self.users = response?.users ?? [User]()
                    DispatchQueue.main.async {
                        if(self.users.count == 0){
                            viewNoNearByDevices.isHidden = false
                            self.tableView.isHidden = true
                        }else {
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                            viewNoNearByDevices.isHidden = true
                        }
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PayeeUserTableViewCell
        let data = users[indexPath.row]
        cell.labelName.text = (data.firstName ?? "") + " " + (data.lastName ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback?(users[indexPath.row])
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickTryAgain(_ sender: Any) {
        getUserList()
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
