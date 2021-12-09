//
//  SendTransactionRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class SendTransactionRequest: Encodable {
    var type: String?
    var senderId: String?
    var sPassword: String?
    var receiverId: String?
    var currency: String?
    var amount: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            "type" ~~> self.type,
            "senderId" ~~> self.senderId,
            "sPassword" ~~> self.sPassword,
            "receiverId" ~~> self.receiverId,
            "currency" ~~> self.currency,
            "amount" ~~> self.amount
            ])
    }
}
