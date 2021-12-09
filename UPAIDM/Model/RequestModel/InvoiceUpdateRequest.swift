//
//  InvoiceUpdateRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import Foundation
import Gloss

class InvoiceUpdateRequest: Encodable {
    var invoiceId: String?
    var updateData: [String:String]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "invoiceId" ~~> self.invoiceId,
            "updateData" ~~> self.updateData
            ])
    }
}

