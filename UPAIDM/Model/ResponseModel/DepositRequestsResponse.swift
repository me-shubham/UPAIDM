//
//  DepositRequestsResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class DepositRequestsResponse: Decodable {
    
    var status: Bool?
    private var _depositRequests: [DepositRequestModel]?
    var depositRequests: [DepositRequestModel]?{
        return _depositRequests
    }
    var msg: String?

    func getDataFromArr(dataArr: NSArray) -> [DepositRequestModel] {
        var dataList = [DepositRequestModel]()
        
        for item in dataArr {
            if let itemData = DepositRequestModel(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["depositRequests"] {
            self._depositRequests = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}


