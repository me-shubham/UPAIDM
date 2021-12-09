//
//  ChangeDepositRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class ChangeDepositRequest: Encodable {
    var depositId: String?
    var updateData: [String:String]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "depositId" ~~> self.depositId,
            "updateData" ~~> self.updateData
            ])
    }
}
