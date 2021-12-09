//
//  WithdrawRequestsResponse.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 10/10/21.
//

import UIKit
import Gloss

final class WithdrawRequestsResponse: Decodable {
    
    var status: Bool?
    private var _withdrawRequests: [WithdrawRequestModel]?
    var withdrawRequests: [WithdrawRequestModel]?{
        return _withdrawRequests
    }
    var msg: String?

    func getDataFromArr(dataArr: NSArray) -> [WithdrawRequestModel] {
        var dataList = [WithdrawRequestModel]()
        
        for item in dataArr {
            if let itemData = WithdrawRequestModel(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["withdrawRequests"] {
            self._withdrawRequests = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}



