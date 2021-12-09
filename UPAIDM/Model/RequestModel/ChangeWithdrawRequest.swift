//
//  ChangeWithdrawRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class ChangeWithdrawRequest: Encodable {
    var withdrawdepositId: String?
    var updateData: [String:String]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "withdrawdepositId" ~~> self.withdrawdepositId,
            "updateData" ~~> self.updateData
            ])
    }
}
