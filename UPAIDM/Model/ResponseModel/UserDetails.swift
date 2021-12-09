//
//  File.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class UserDetails: Decodable {
    
    var status: Bool?
    var user: User?
    var msg: String?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["user"] {
            user = User((data as? JSON) ?? JSON())
        }
    }

}

