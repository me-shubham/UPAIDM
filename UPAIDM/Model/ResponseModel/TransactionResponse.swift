//
//  TransactionResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class TransactionResponse: Decodable {
    
    var status: Bool?
    var transaction: Transaction?
    var msg: String?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["transaction"] {
            transaction = Transaction((data as? JSON) ?? JSON())
        }
    }

}
