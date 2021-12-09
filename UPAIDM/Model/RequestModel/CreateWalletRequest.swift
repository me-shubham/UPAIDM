//
//  CreateWalletRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import Foundation
import Gloss

class CreateWalletRequest: Encodable {
    var userId: String?
    var password: String?
    
    func toJSON() -> JSON? {
        return jsonify([
            "userId" ~~> self.userId,
            "password" ~~> self.password
            ])
    }
}

