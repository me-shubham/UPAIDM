//
//  WithdrawTransactionRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class WithdrawTransactionRequest: Encodable {
    var walletId: String?
    var password: String?
    var currency: String?
    var target: String?
    var address: String?
    var iban: String?
    var amount: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            "walletId" ~~> self.walletId,
            "password" ~~> self.password,
            "currency" ~~> self.currency,
            "target" ~~> self.target,
            "address" ~~> self.address,
            "iban" ~~> self.iban,
            "amount" ~~> self.amount
            ])
    }
}

