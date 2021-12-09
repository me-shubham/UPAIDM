//
//  DepositRequestModel.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class DepositRequestModel: Decodable {
    
    var _id: String?
    var userId: String?
    var type: String?
    var currency: String?
    var amount: Double?
    var iban: Int64?
    var __v: Double?
    var status: String?
    
   
    init?(_ json: JSON) {
        _id = "_id" <~~ json
        userId = "userId" <~~ json
        type = "type" <~~ json
        currency = "currency" <~~ json
        amount = "amount" <~~ json
        iban = "iban" <~~ json
        __v = "__v" <~~ json
        status = "status" <~~ json
   }
}

