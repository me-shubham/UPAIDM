//
//  UseWalletRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import Foundation
import Gloss

class UseWalletRequest: Encodable {
    var userId: String?
    var walletId: String?
    
    func toJSON() -> JSON? {
        return jsonify([
            "userId" ~~> self.userId,
            "walletId" ~~> self.walletId
            ])
    }
}
