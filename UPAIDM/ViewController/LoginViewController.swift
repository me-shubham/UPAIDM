//
//  LoginViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 29/01/21.
//

import UIKit
import SwiftSpinner
import Toaster

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    let requestModel = UserRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonContinue.layer.cornerRadius = 15
        buttonContinue.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
        if(textFieldEmail.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter Email."), animated: true, completion: nil)
            return
        }
        
        if(textFieldPassword.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter password."), animated: true, completion: nil)
            return
        }
        
        
        if Reachability()?.connection == Reachability.Connection.none {
            
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        } else {
            
            SwiftSpinner.show("")
            requestModel.email = textFieldEmail.text
            requestModel.password = textFieldPassword.text
            
            ApiManager.sharedInstance.login(data: requestModel){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? true{
                        userDefaults.set(response.userId, forKey: UDKeys.userId)
                        userDefaults.set(true, forKey: UDKeys.isLogin)
                        userDefaults.synchronize()
                        Toast(text: "Successfully login.", duration: Delay.short).show()
                        self.goToHome()
                    }else{
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
       
//        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickForgotPassword(_ sender: Any) {
        self.present(commonAlert(title: "Alert", message: "Under development."), animated: true, completion: nil)
        
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
