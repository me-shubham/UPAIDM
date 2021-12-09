//
//  Transaction.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class Transaction: Decodable {
    
    var _id: String?
    var currencyType: String?
    var paging_token: String?
    var source_account: String?
    var content: String?
    var time: Int64?
    var transaction_hash: String?
    var starting_balance: String?
    var funder: String?
    var transaction_successful: Int?
    var senderId: String?
    var sPublicKey: String?
    var receiverId: String?
    var rPublicKey: String?
    var currency: String?
    var amount: Double?
    
   
    init?(_ json: JSON) {
        _id = "_id" <~~ json
        currencyType = "currencyType" <~~ json
        paging_token = "paging_token" <~~ json
        source_account = "source_account" <~~ json
        time = "time" <~~ json
        content = "content" <~~ json
        transaction_hash = "transaction_hash" <~~ json
        starting_balance = "starting_balance" <~~ json
        funder = "funder" <~~ json
        transaction_successful = "transaction_successful" <~~ json
        senderId = "senderId" <~~ json
        sPublicKey = "sPublicKey" <~~ json
        receiverId = "receiverId" <~~ json
        rPublicKey = "rPublicKey" <~~ json
        currency = "currency" <~~ json
        amount = "amount" <~~ json
   }
}
