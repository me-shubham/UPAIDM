//
//  CreateInvoiceResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class CreateInvoiceResponse: Decodable {
    
    var status: Bool?
    var invoice: Invoice?
    var msg: String?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["invoice"] {
            invoice = Invoice((data as? JSON) ?? JSON())
        }
    }

}

