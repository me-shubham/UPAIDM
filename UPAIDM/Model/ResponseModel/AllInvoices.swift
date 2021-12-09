//
//  AllInvoices.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class AllInvoices: Decodable {
    
    var status: Bool?
    private var _invoices: [Invoice]?
    var invoices: [Invoice]?{
        return _invoices
    }
    var msg: String?

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
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["invoice"] {
            self._invoices = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}


