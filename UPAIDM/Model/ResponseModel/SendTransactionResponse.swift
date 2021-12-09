//
//  SendTransactionResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class SendTransactionResponse: Decodable {
    
    var status: Bool? = true
    var msg: String?
    var sender: String?
    var receiver: String?
    var currency: String?
    var amount: Double?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        sender = "sender" <~~ json
        receiver = "receiver" <~~ json
        currency = "currency" <~~ json
        amount = "amount" <~~ json
    }

}
