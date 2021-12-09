//
//  DepositTransactionRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class DepositTransactionRequest: Encodable {
    var userId: String?
    var type: String?
    var currency: String?
    var iban: String?
    var amount: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            "userId" ~~> self.userId,
            "type" ~~> self.type,
            "currency" ~~> self.currency,
            "iban" ~~> self.iban,
            "amount" ~~> self.amount
            ])
    }
}

