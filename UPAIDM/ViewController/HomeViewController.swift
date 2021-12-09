//
//  HomeViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 01/02/21.
//

import UIKit
import CoreLocation
import SwiftSpinner
import CoreNFC
import LocalAuthentication
import SwiftGifOrigin
import DropDown

class HomeViewController: UIViewController, CLLocationManagerDelegate, NFCNDEFReaderSessionDelegate {
    
    
    @IBOutlet weak var viewOfFourViews: NeumorphismView!
    @IBOutlet weak var bottomViewConstraintInScrollView: NSLayoutConstraint!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCurrencyType: UILabel!
    @IBOutlet weak var labelWelcomeName: UILabel!
    @IBOutlet weak var viewPay: UIView!
    @IBOutlet weak var viewCommitToPay: UIView!
    @IBOutlet weak var viewMyAccount: UIView!
    @IBOutlet weak var viewBePaid: UIView!
    
    @IBOutlet weak var labelBePaid: UILabel!
    @IBOutlet weak var labelDescriptionBePaid: UILabel!
    @IBOutlet weak var imageViewBePaid: UIImageView!
    
    @IBOutlet weak var buttonInfo: NeumorphismButton!
    @IBOutlet weak var buttonHistory: NeumorphismButton!
    @IBOutlet weak var buttonHome: NeumorphismButton!
    @IBOutlet weak var buttonNotification: NeumorphismButton!
    @IBOutlet weak var buttonHelp: NeumorphismButton!
    @IBOutlet weak var logoImageView: UIImageView!

    
    let locationManager = CLLocationManager()
    var user : User!
    var wallet : Wallet?
    let dropDown = DropDown()
    var nfcSession: NFCNDEFReaderSession?
    var payeeUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.loadGif(name: "Logo_GIF_2.0_final")
        
        self.user = (UIApplication.shared.delegate as? AppDelegate)?.user
        buttonHome.isConvex = 0
        buttonInfo.cornerRadius = 8
        buttonHistory.cornerRadius = 8
        buttonHome.cornerRadius = 8
        buttonNotification.cornerRadius = 8
        buttonHelp.cornerRadius = 8
        
        viewOfFourViews.isHidden = false
        self.bottomViewConstraintInScrollView.constant = 20
        
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
        let myAccount = UITapGestureRecognizer(target: self, action: #selector(self.onTapMyAccount(_:)))
        viewMyAccount.addGestureRecognizer(myAccount)
        
        let tapCommitToPay = UITapGestureRecognizer(target: self, action: #selector(self.onTapCommitToPay(_:)))
        viewCommitToPay.addGestureRecognizer(tapCommitToPay)
        
        let tapPay = UITapGestureRecognizer(target: self, action: #selector(self.onTapPay(_:)))
        viewPay.addGestureRecognizer(tapPay)
        
        let bePaid = UITapGestureRecognizer(target: self, action: #selector(self.onTapBePaid(_:)))
        viewBePaid.addGestureRecognizer(bePaid)
        
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        buttonHome.isConvex = 0
        
        fetchUserData()
        
        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType), let currencyAmount = userDefaults.string(forKey: UDKeys.currencyAmount) {
            
            self.labelCurrencyType.text = currencyType
            
            let walletAmount = Double(currencyAmount)
            
            self.labelAmount.text = "\(walletAmount?.rounded(toPlaces: 2) ?? 0.0)"
            
        }
        
    }
    
    @objc func onTapMyAccount(_ sender: UITapGestureRecognizer? = nil) {
        self.performSegue(withIdentifier: "MyAccount", sender: self)
    }
    
    @objc func onTapCommitToPay(_ sender: UITapGestureRecognizer? = nil) {
        self.performSegue(withIdentifier: "AlertView", sender: self)
    }
    
    @objc func onTapPay(_ sender: UITapGestureRecognizer? = nil) {
        if(userDefaults.bool(forKey: UDKeys.isAuthenticated)){
            self.performSegue(withIdentifier: "PayOptionAlert", sender: self)
        }else{
            authenticationWithTouchID()
        }
    }
    
    @objc func onTapBePaid(_ sender: UITapGestureRecognizer? = nil) {
            self.performSegue(withIdentifier: "CreateInvoice", sender: self)
    }
    
    func authenticationWithTouchID() {
        
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"

        var authorizationError: NSError?
        let reason = "Authentication required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                
                if success {
                    
                    DispatchQueue.main.async() {
                        userDefaults.set(true, forKey: UDKeys.isAuthenticated)
                        self.performSegue(withIdentifier: "PayOptionAlert", sender: self)
                    }
                    
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(error)
                
                }
            }
            
        } else {
            
            guard let error = authorizationError else {
                return
            }
            
            print(error)
        }
        
    }
    
    func fetchUserData() {
        
        if Reachability()?.connection == Reachability.Connection.none{
            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
        }else{
            SwiftSpinner.show("")
            guard let userId = userDefaults.string(forKey: UDKeys.userId) else
            {
                self.goToLogin()
                return
            }
            
            ApiManager.sharedInstance.sessionByUserId(userId: userId){ [self] (response) in
                if let response = response{
                    if response.status ?? false {
                        ApiManager.sharedInstance.getUserDetails(userId: userId){ [self] (response) in
                            SwiftSpinner.hide()
                            
                            if let response = response {
                                
                                if response.status ?? false {
                                    self.user = response.user
                                    DispatchQueue.main.async {
                                        
                                        self.labelWelcomeName.text = "Hey, " + (user.firstName ?? "") + " " + (user.lastName ?? "")
                                        
                                        userDefaults.set("\(user.firstName ?? "") \(user.lastName ?? "")", forKey: UDKeys.userFullName)
                                        
                                        userDefaults.synchronize()
                                    }
                                    
                                } else {
                                    self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                                }
                            }else{
                                self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                        
                        ApiManager.sharedInstance.myWallets(userId: userId){ [self] (response) in
                            
                            SwiftSpinner.hide()
                            
                            if let response = response {
                                
                                if (response.wallets?.count ?? 0) > 0 {
                                    
                                    self.wallet = response.wallets?.filter{$0.usage == true}.first
                                    DispatchQueue.main.async {
                                        if let currencyType = userDefaults.string(forKey: UDKeys.currencyType) {
                                            self.labelCurrencyType.text = currencyType
                                            switch currencyType {
                                            case "€":
                                                self.labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "$":
                                                self.labelAmount.text = "\(self.wallet?.USD?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "£":
                                                self.labelAmount.text = "\(self.wallet?.GBP?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "Fr":
                                                self.labelAmount.text = "\(self.wallet?.CHF?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "MSC1":
                                                self.labelAmount.text = "\(self.wallet?.MSC1?.rounded(toPlaces: 2) ?? 0.0)"
                                            case "XLM":
                                                self.labelAmount.text = "\(self.wallet?.XLM?.rounded(toPlaces: 2) ?? 0.0)"
                                                
                                            default:
                                                self.labelAmount.text = "0.0"
                                            }
                                        } else {
                                            
                                            self.labelCurrencyType.text = "€"
                                            self.labelAmount.text = "\(self.wallet?.EUR?.rounded(toPlaces: 2) ?? 0.0)"
                                        }
                                        
                                        self.becomeFirstResponder()
                                    }
                                    
                                } else {
                                    
                                    self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                                }
                                
                            }else{
                                
                                self.present(commonAlert(title: "Alert", message: "Something went wrong."), animated: true, completion: nil)
                            }
                        }
                        
                    }else{
                        
                        SwiftSpinner.hide()
                        self.goToLogin()
                        self.present(commonAlert(title: "Alert", message: response.msg ?? "Something went wrong."), animated: true, completion: nil)
                    }
                }else{
                    
                    SwiftSpinner.hide()
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
    
    @IBAction func onClickInfo(_ sender: NeumorphismButton) {
        
        self.moveToAnotherTab(identifier: "AboutUsViewController", animation: false)
        
    }
    
    @IBAction func onClickHistory(_ sender: NeumorphismButton) {
        
        self.moveToAnotherTab(identifier: "HelpAndSupportViewController", animation: false)
    }
    
    @IBAction func onClickHome(_ sender: NeumorphismButton) {
        buttonHome.isConvex = 0
    }
    
    
    
    @IBAction func onClickNotification(_ sender: NeumorphismButton) {
        
        self.moveToAnotherTab(identifier: "TermsAndConditionsViewController", animation: false)
        
    }
    
    
    @IBAction func onClickHelp(_ sender: NeumorphismButton) {
        
        self.moveToAnotherTab(identifier: "CyptoTabViewController", animation: false)
        
    }
    
    
    @IBAction func onClickProfile(_ sender: NeumorphismButton) {
        
        self.performSegue(withIdentifier: "ProfileVC", sender: self)
    }
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
       
        var result = ""
        for message in messages {
            
                for record in message.records {
                    
                    if let string = String(data: record.payload, encoding: .utf8) {
                        result += string
                    }

                }
            
            }
        
        nfcSession?.invalidate()
        
        if result == "" {
            
            self.present(commonAlert(title: "Alert", message: "Not sufficiant details in NFC Tag."), animated: true, completion: nil)
            
        } else {
            
            DispatchQueue.main.async() {
                
                self.performSegue(withIdentifier: "PayInvoice", sender: result)
                
            }
        }
        
    }
    
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if(userDefaults.bool(forKey: UDKeys.isAuthenticated)){
                self.performSegue(withIdentifier: "PayOptionAlert", sender: self)
            }else{
                authenticationWithTouchID()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let data = UpdateUserLocationRequest()
        
        guard let userId = userDefaults.string(forKey: UDKeys.userId) else { return }
        data.userId = userId
        data.updateData = ["latitude": locValue.latitude, "longitude": locValue.longitude]
        
        ApiManager.sharedInstance.updateUserLocation(data: data){ (response) in
         }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "AlertView"){
            if let viewController = segue.destination as? AlertViewController {
                viewController.titleAlert = "Application Status"
                viewController.messageAlert = "Your application is under development...!"
            }
        }
        
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
        
        if(segue.identifier == "MyAccount"){
            if let viewController = segue.destination as? MyAccountViewController {
                viewController.user = self.user
                viewController.wallet = self.wallet
            }
        }
        
        if(segue.identifier == "CreateInvoice"){
            if let viewController = segue.destination as? CreateInvoiceViewController {
                viewController.user = self.user
                viewController.wallet = self.wallet
            }
        }
        
        if(segue.identifier == "PayOptionAlert"){
            if let viewControllerB = segue.destination as? PayOptionAlertViewController {
                viewControllerB.callback = { tag in
                    //Do what you want in here!
                    viewControllerB.dismiss(animated: true, completion: nil)
                    if(tag == 1){
                        self.nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
                        self.nfcSession?.alertMessage = "Tap your NFC tag on mobile to write."
                        self.nfcSession?.begin()
                    }else if(tag == 2){
                        self.performSegue(withIdentifier: "Reader", sender: self)
                    }else if(tag == 3){
                        self.performSegue(withIdentifier: "PayInvoice", sender: nil)
                    }else if(tag == 4){
                        if Reachability()?.connection == Reachability.Connection.none{
                            
                            self.present(commonAlert(title: "Alert", message: "Please check your internet connection."), animated: true, completion: nil)
                        }else{
                            guard let userId = userDefaults.string(forKey: UDKeys.userId) else {
                                return
                            }
                            SwiftSpinner.show("")
                            ApiManager.sharedInstance.getInvoicePayeeList(userId: userId){ [self] (response) in
                                SwiftSpinner.hide()
                                if response?.status ?? false {
                                    if (response?.users?.count ?? 0) > 0 {
                                            self.performSegue(withIdentifier: "SelectUser", sender: response?.users)
                                        }else {
                                            self.present(commonAlertWithAction(title: "Alert", message: "No nearby user exists who genrate an invoice.", viewController: self), animated: true)
                                        }
                                    }else {
                                        self.present(commonAlertWithAction(title: "Alert", message: "Scaned transaction is not available, please ask the owner to resend.", viewController: self), animated: true)
                                    }
                            }
                        }
            }else {
                        viewControllerB.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        if(segue.identifier == "Reader"){
            if let viewControllerB = segue.destination as? ReaderViewController {
                viewControllerB.callback = { trasactionId in
                    //Do what you want in here!
                    self.navigationController?.popViewController(animated: false)
                    if(trasactionId == ""){
                        self.present(commonAlert(title: "Alert", message: "Not sufficiant details in QR code."), animated: true, completion: nil)
                    }else{
                        self.performSegue(withIdentifier: "PayInvoice", sender: trasactionId)
                    }
                        
                }
            }
        }
       
        if(segue.identifier == "PayInvoice"){
            if let viewController = segue.destination as? InvoiceAproveViewController {
                viewController.user = self.user
                viewController.wallet = self.wallet
                viewController.transactionId = sender as? String ?? ""
                viewController.payeeUserId = self.payeeUserId
                self.payeeUserId = ""
            }
        }
        
       if(segue.identifier == "SelectUser"){
            if let viewControllerB = segue.destination as? SelectUserViewController {
                viewControllerB.users = sender as? [User] ?? [User]()
                viewControllerB.callback = { user in
                    //Do what you want in here!
                    self.navigationController?.popViewController(animated: false)
                    self.payeeUserId = user?._id ?? ""
                    self.performSegue(withIdentifier: "PayInvoice", sender: nil)
//                    if let invoiceId = user?.invoiceData?[0]._id {
//                        self.performSegue(withIdentifier: "PayInvoice", sender: invoiceId)
//                    }else {
//                        self.present(commonAlert(title: "Alert", message: "No invoice exists for selected user."), animated: true, completion: nil)
//                    }
                }
            }
        }
    }
    

}
