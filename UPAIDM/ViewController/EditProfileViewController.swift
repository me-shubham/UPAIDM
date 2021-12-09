//
//  EditProfileViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import UIKit
import SwiftSpinner

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var labelFlag: UILabel!
    @IBOutlet weak var labelCountryCode: UILabel!
    @IBOutlet weak var buttonSaveProfile: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    let requestModel = UpdateUserRequest()
    var user : User!
    var callback : ((User?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSaveProfile.layer.cornerRadius = 15
        buttonSaveProfile.clipsToBounds = true
        if let code = Locale.current.regionCode{
            labelFlag.text = String.emojiFlag(for: code)
            labelCountryCode.text = "+" + (getCountryPhonceCode(code) ?? "")
        }
        setupUIData()
    }
    
    func setupUIData(){
        textFieldFirstName.text = user.firstName
        textFieldLastName.text = user.lastName
        textFieldEmail.text = user.email
        textFieldPhoneNumber.text = user.phoneNumber
        labelCountryCode.text = user.countryCode
        let pinCode = user.countryCode?.suffix((user.countryCode?.count ?? 0)-1) ?? ""
        let code = getCountryCode(String(pinCode))
        labelFlag.text = String.emojiFlag(for: code ?? "")
    }
    
    @IBAction func onClickSaveProfile(_ sender: Any) {
        
        if(textFieldFirstName.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter first name."), animated: true, completion: nil)
            return
        }
        if(textFieldEmail.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter email."), animated: true, completion: nil)
            return
        }
        if(textFieldPhoneNumber.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter phone number."), animated: true, completion: nil)
            return
        }
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            SwiftSpinner.show("")
            var updateData = [String:String]()
            updateData["firstName"] = textFieldFirstName.text
            updateData["lastName"] = textFieldLastName.text
            updateData["email"] = textFieldEmail.text
            updateData["countryCode"] = labelCountryCode.text
            updateData["phoneNumber"] = textFieldPhoneNumber.text
            requestModel.userId = user._id
            requestModel.updateData = updateData
            ApiManager.sharedInstance.updateUser(data: requestModel){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? false {
                        callback?(response.user)
                        self.navigationController?.popViewController(animated: true)
                    } else{
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func onClickEditProfileImage(_ sender: Any) {
        self.present(commonAlert(title: "Alert", message: "Under development."), animated: true, completion: nil)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCountryCodeAndFlag(_ sender: Any) {
        self.performSegue(withIdentifier: "CountryList", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "CountryList"){
            let vc = segue.destination as? ContryListViewController
            vc?.countryInfo = { [weak self] (info) in
                self?.labelFlag.text = info.flag
                self?.labelCountryCode.text = "+" + info.code
                
            }
            
        }
    }
    

}
