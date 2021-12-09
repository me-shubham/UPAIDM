//
//  Wallet.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class Wallet: Decodable {
    
    var _id: String?
    var userId: String?
    var password: String?
    var publicKey: String?
    var keyStore: String?
    var EUR: Double?
    var USD: Double?
    var CHF: Double?
    var GBP: Double?
    var XLM: Double?
    var MSC1: Double?
    var usage: Bool?
    var __v: Double?
    
   
    init?(_ json: JSON) {
        _id = "_id" <~~ json
        userId = "userId" <~~ json
        password = "password" <~~ json
        publicKey = "publicKey" <~~ json
        keyStore = "keyStore" <~~ json
        EUR = "EUR" <~~ json
        USD = "USD" <~~ json
        CHF = "CHF" <~~ json
        GBP = "GBP" <~~ json
        XLM = "XLM" <~~ json
        MSC1 = "msc1" <~~ json
        usage = "usage" <~~ json
        __v = "__v" <~~ json
    }
}

