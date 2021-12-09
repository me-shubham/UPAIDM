//
//  WithdrawRequestModel.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class WithdrawRequestModel: Decodable {
    
    var _id: String?
    var walletId: String?
    var password: String?
    var target: String?
    var address: String?
    var currency: String?
    var amount: Double?
    var iban: Int64?
    var __v: Double?
    var status: String?
    
   
    init?(_ json: JSON) {
        _id = "_id" <~~ json
        walletId = "walletId" <~~ json
        password = "password" <~~ json
        target = "target" <~~ json
        address = "address" <~~ json
        currency = "currency" <~~ json
        amount = "amount" <~~ json
        iban = "iban" <~~ json
        __v = "__v" <~~ json
        status = "status" <~~ json
   }
}
