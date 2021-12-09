//
//  GenricResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class GenricResponse: Decodable {
    
    var status: Bool?
    var msg: String?
    var token: String?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        token = "token" <~~ json
    }

}


