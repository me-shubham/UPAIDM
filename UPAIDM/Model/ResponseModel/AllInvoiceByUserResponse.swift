//
//  AllInvoiceByUser.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class AllInvoiceByUserResponse: Decodable {
    
    var status: Bool?
    var invoices: AllInvoiceByUser?
    var msg: String?
   
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["invoices"] {
            invoices = AllInvoiceByUser((data as? JSON) ?? JSON())
        }
    }

}


final class AllInvoiceByUser: Decodable {
    
    private var _sent: [Invoice]?
    var sent: [Invoice]?{
        return _sent
    }
    private var _recieved: [Invoice]?
    var recieved: [Invoice]?{
        return _recieved
    }

    func getDataFromArr(dataArr: NSArray) -> [Invoice] {
        var dataList = [Invoice]()
        
        for item in dataArr {
            if let itemData = Invoice(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: JSON) {
        if let data = json["sent"] {
            self._sent = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
        if let data = json["recieved"] {
            self._recieved = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}


