//
//  TransactionsList.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class TransactionsList: Decodable {
    
    var status: Bool?
    private var _transactions: [Transaction]?
    var transactions: [Transaction]?{
        return _transactions
    }
    var msg: String?

    func getDataFromArr(dataArr: NSArray) -> [Transaction] {
        var dataList = [Transaction]()
        
        for item in dataArr {
            if let itemData = Transaction(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["transactions"] {
            self._transactions = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}

