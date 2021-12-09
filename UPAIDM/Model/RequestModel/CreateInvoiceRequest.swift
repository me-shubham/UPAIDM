//
//  CreateInvoiceRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//
//{
//    "sender": "613b217e4ae5df109c7420b6",
//    "receiver": "6124dc099909b81a84bbca23",
//    "business": "testing",
//    "date": "2021-9-27",
//    "reason": "Invoice Test",
//    "type": "fiat",
//    "currency": "USD",
//    "amount": 1000
//}
import Foundation
import Gloss

class CreateInvoiceRequest: Encodable {
    var sender: String?
    var receiver: String?
    var business: String?
    var date: String?
    var reason: String?
    var type: String?
    var currency: String?
    var amount: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            "sender" ~~> self.sender,
            "receiver" ~~> self.receiver,
            "business" ~~> self.business,
            "date" ~~> self.date,
            "reason" ~~> self.reason,
            "type" ~~> self.type,
            "currency" ~~> self.currency,
            "amount" ~~> self.amount
            ])
    }
}

