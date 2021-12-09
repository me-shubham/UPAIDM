//
//  ProfileAlertViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 01/02/21.
//

import UIKit
import SwiftSpinner

class ProfileAlertViewController: UIViewController {
    
    @IBOutlet weak var labelAppVersion: UILabel!
    @IBOutlet weak var buttonViewProfile: UIButton!
    @IBOutlet weak var viewBack: UIView!
    
    var callback : ((Int?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonViewProfile.layer.cornerRadius = 15
        buttonViewProfile.clipsToBounds = true
        viewBack.layer.cornerRadius = 8
        viewBack.clipsToBounds = true

        self.labelAppVersion.text = "App version \(appVersion ?? "")"
        // Do any additional setup after loading the view.
        print("Shubham")
        
    }
    
    @IBAction func onClickExit(_ sender: NeumorphismButton) {
        self.onClickLogout(NeumorphismButton())
    }
    
    @IBAction func onClickViewProfile(_ sender: UIButton) {
        callback?(0)
    }
        
    @IBAction func onClickLogout(_ sender: NeumorphismButton) {
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                return
            }
            SwiftSpinner.show("")
            ApiManager.sharedInstance.signOut(userId: userId){ [self] (response) in
                SwiftSpinner.hide()
                if response?.status ?? false {
                    userDefaults.set(false, forKey: UDKeys.isLogin)
                    userDefaults.synchronize()
                    goToLogin()
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
        
        
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
