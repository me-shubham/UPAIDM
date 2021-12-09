//
//  Invoice.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class Invoice: Decodable {
    
    var _id: String?
    var sender: String?
    var receiver: String?
    var business: String?
    var date: String?
    var reason: String?
    var type: String?
    var currency: String?
    var amount: Double?
    var status: Bool?
    var __v: Double?
   
    init?(_ json: JSON) {
        _id = "_id" <~~ json
        sender = "sender" <~~ json
        receiver = "receiver" <~~ json
        business = "business" <~~ json
        date = "date" <~~ json
        reason = "reason" <~~ json
        type = "type" <~~ json
        currency = "currency" <~~ json
        amount = "amount" <~~ json
        status = "status" <~~ json
        __v = "__v" <~~ json
    }

}

