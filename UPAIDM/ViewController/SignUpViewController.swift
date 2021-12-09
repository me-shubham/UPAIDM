//
//  SignUpViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import UIKit
import SwiftSpinner
import CoreLocation
import Toaster

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatPassword: UITextField!
    @IBOutlet weak var labelFlag: UILabel!
    @IBOutlet weak var labelCountryCode: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    let requestModel = UserRequest()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonContinue.layer.cornerRadius = 15
        buttonContinue.clipsToBounds = true

        if let code = Locale.current.regionCode{
            labelFlag.text = String.emojiFlag(for: code)
            labelCountryCode.text = "+" + (getCountryPhonceCode(code) ?? "")
        }
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        requestModel.latitude = locValue.latitude
        requestModel.longitude = locValue.longitude
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
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
        if(textFieldPassword.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter password."), animated: true, completion: nil)
            return
        }
        if(textFieldRepeatPassword.text == ""){
            self.present(commonAlert(title: "Alert", message: "Please enter repeat password."), animated: true, completion: nil)
            return
        }
        if(textFieldRepeatPassword.text != textFieldPassword.text){
            self.present(commonAlert(title: "Alert", message: "Password and repeat password does not match."), animated: true, completion: nil)
            return
        }
        
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            SwiftSpinner.show("")
            requestModel.firstName = textFieldFirstName.text
            requestModel.lastName = textFieldLastName.text
            requestModel.phoneNumber = textFieldPhoneNumber.text
            requestModel.countryCode = labelCountryCode.text
            requestModel.email = textFieldEmail.text
            requestModel.password = textFieldPassword.text
            
            ApiManager.sharedInstance.signUp(data: requestModel){ [self] (response) in
                SwiftSpinner.hide()
                if let response = response{
                    if response.status ?? true{
                        Toast(text: "Successfully registered.", duration: Delay.short).show()
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func onClickForgotPassword(_ sender: Any) {
        self.present(commonAlert(title: "Alert", message: "Under development."), animated: true, completion: nil)
        
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
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
