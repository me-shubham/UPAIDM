//
//  ApiManager.swift
//  CardGuard
//
//  Created by Admin on 15.12.16.
//  Copyright © 2016 Amit. All rights reserved.
//

import Foundation
import Gloss
import Alamofire
import CoreLocation
import Firebase

class ApiManager {
    //Singleton implementation
    
    static let sharedInstance = ApiManager()
    private var reachability : Reachability!
    static let loginURL = "/users/userLogin"
    static let userDetailsURL = "/users/getUserDetail"
    static let allUsersURL = "/users/getAllUsers"
    static let registerURL = "/users/userRegister"
    static let signOutURL = "/users/userLogout"
    static let getNearByUsersURL = "/users/getNearByUsers"
    static let getFirebastTokenURL = "/users/getFirebastToken"
    static let updateUserURL = "/users/updateUser"
    static let generateInvoiceURL = "/invoice/generateInvoice"
    static let getNearbySpecifyUsersURL = "/invoice/getNearbySpecifyUsers"
    static let getLatestInvoiceByUserIDURL = "/invoice/getLatestInvoiceByUserID"
    static let allInvoicesURL = "/invoice/getAllInvoices"
    static let getInvoiceByIDURL = "/invoice/getInvoiceByID"
    static let getInvoicePayeeURL = "/invoice/getPayee"
    static let updateInvoiceURL = "/invoice/update"
    static let allInvoiceByUserURL = "/invoice/allInvoiceByUser"
    static let sessionByUserIdURL = "/sessions/sessionByUserId"
    static let getWalletInfoURL = "/wallets/getWalletInfo"
    static let myWalletsURL = "/wallets/myWallets"
    static let createWalletURL = "/wallets/createWallet"
    static let useWalletURL = "/wallets/useWallet"
    static let removeWalletURL = "/wallets/removeWallet"
    static let sendTransactionsURL = "/transactions/send"
    static let allTransactionsURL = "/transactions/allTransactions"
    static let latestTransactionURL = "/transactions/latestTransaction"
    static let getAllDepositRequestsURL = "/transactions/getAllDepositRequests"
    static let depositRequestURL = "/transactions/depositRequest"
    static let changeDepReqURL = "/transactions/changeDepReq"
    static let getAllWithdrawRequestsURL = "/transactions/getAllWithdrawRequests"
    static let withdrawRequestURL = "/transactions/withdrawRequest"
    static let changeWithReqURL = "/transactions/changeWithReq"
    
    //
    let defaultManager = Alamofire.Session.default
    
    func observeReachability(){
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            print("Network available via Cellular Data.")
            break
        case .wifi:
            print("Network available via WiFi.")
            break
        case .none:
            print("Network is not available.")
            break
        }
    }

    func login(data: UserRequest, completion: @escaping (User?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.loginURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = User(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getUserDetails(userId: String, completion: @escaping (UserDetails?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.userDetailsURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = UserDetails(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func updateUser(data: UpdateUserRequest, completion: @escaping (UserDetails?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.updateUserURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = UserDetails(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func updateUserLocation(data: UpdateUserLocationRequest, completion: @escaping (UserDetails?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.updateUserURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = UserDetails(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getFirebastToken(userId: String, completion: @escaping (GenricResponse?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.getFirebastTokenURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getNearByUsers(userId: String, completion: @escaping (AllUsers?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.getNearByUsersURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllUsers(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getAllUsers(completion: @escaping (AllUsers?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.allUsersURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllUsers(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func signUp(data: UserRequest,completion: @escaping (User?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.registerURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = User(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func sessionByUserId(userId: String, completion: @escaping (GenricResponse?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.sessionByUserIdURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func signOut(userId: String, completion: @escaping (GenricResponse?) -> ()) {
        let url = baseUrl + ApiManager.signOutURL + "?userId=" + userId
        defaultManager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func createInvoice(data: CreateInvoiceRequest,completion: @escaping (CreateInvoiceResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.generateInvoiceURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = CreateInvoiceResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getNearbySpecifyUsers(userId: String, completion: @escaping (AllUsers?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.getNearbySpecifyUsersURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllUsers(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getLatestInvoiceByUserID(userId: String, completion: @escaping (CreateInvoiceResponse?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.getLatestInvoiceByUserIDURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = CreateInvoiceResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getInvoiceByID(invoiceId: String, completion: @escaping (CreateInvoiceResponse?) -> ()) {
        let parameters: Parameters = [
                "invoiceId": invoiceId
                ]
        defaultManager.request(baseUrl + ApiManager.getInvoiceByIDURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = CreateInvoiceResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getAllInvoices(completion: @escaping (AllInvoices?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.allInvoicesURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllInvoices(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getInvoicePayeeList(userId: String, completion: @escaping (AllUsers?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.getInvoicePayeeURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllUsers(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func updateInvoice(data: InvoiceUpdateRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.updateInvoiceURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getAllInvoiceByUser(userId: String, completion: @escaping (AllInvoiceByUserResponse?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.allInvoiceByUserURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = AllInvoiceByUserResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getWalletInfo(walletId: String, completion: @escaping (Wallet?) -> ()) {
        let parameters: Parameters = [
                "walletId": walletId
                ]
        defaultManager.request(baseUrl + ApiManager.getWalletInfoURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = Wallet(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func myWallets(userId: String, completion: @escaping (WalletList?) -> ()) {
        let parameters: Parameters = [
                "userId": userId
                ]
        defaultManager.request(baseUrl + ApiManager.myWalletsURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value{
                print("wallet response: ", json)
                if let responseModel = WalletList(json  as! [Wallet]) {
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    func createWallet(data: CreateWalletRequest, completion: @escaping (WalletList?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.createWalletURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value{
                if let responseModel = WalletList(json  as! [Wallet]) {
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func useWallet(data: UseWalletRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.useWalletURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func removeWallet(userId: String, walletId: String, completion: @escaping (GenricResponse?) -> ()) {
        let url = baseUrl + ApiManager.removeWalletURL + "?userId=" + userId + "&walletId=" + walletId
    
        defaultManager.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func sendTransactions(data: SendTransactionRequest, completion: @escaping (SendTransactionResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.sendTransactionsURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = SendTransactionResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func allTransactions(walletId: String, completion: @escaping (TransactionsList?) -> ()) {
        let parameters: Parameters = [
                "walletId": walletId
                ]
        defaultManager.request(baseUrl + ApiManager.allTransactionsURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = TransactionsList(json){
                    
                    print("json: ", json)
                    
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func latestTransaction(walletId: String, completion: @escaping (TransactionResponse?) -> ()) {
        let parameters: Parameters = [
                "walletId": walletId
                ]
        defaultManager.request(baseUrl + ApiManager.latestTransactionURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = TransactionResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getAllDepositRequests(completion: @escaping (DepositRequestsResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.getAllDepositRequestsURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = DepositRequestsResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func depositRequest(data: DepositTransactionRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.depositRequestURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
   
    func changeDepReq(data: ChangeDepositRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.changeDepReqURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func getAllWithdrawRequests(completion: @escaping (WithdrawRequestsResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.getAllWithdrawRequestsURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = WithdrawRequestsResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func withdrawRequest(data: WithdrawTransactionRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.withdrawRequestURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
   
    func changeWithReq(data: ChangeWithdrawRequest, completion: @escaping (GenricResponse?) -> ()) {
        defaultManager.request(baseUrl + ApiManager.changeWithReqURL, method: .post, parameters: data.toJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let json = response.value as? JSON {
                if let responseModel = GenricResponse(json){
                    completion(responseModel)
                    return
                }
            }else{
                completion(nil)
            }
        }
    }
}

