//
//  UpdateUserRequest.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import Foundation
import Gloss

class UpdateUserRequest: Encodable {
    var userId: String?
    var updateData: [String:String]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "userId" ~~> self.userId,
            "updateData" ~~> self.updateData
            ])
    }
}

class UpdateUserLocationRequest: Encodable {
    var userId: String?
    var updateData: [String:Double]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "userId" ~~> self.userId,
            "updateData" ~~> self.updateData
            ])
    }
}
