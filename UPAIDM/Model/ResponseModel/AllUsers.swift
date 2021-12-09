//
//  AllUsers.swift
//  UPAIDM
//
//  Created by Srajan Singhal on 01/10/21.
//

import UIKit
import Gloss

final class AllUsers: Decodable {
    
    var status: Bool?
    private var _users: [User]?
    var users: [User]?{
        return _users
    }
    var msg: String?

    func getDataFromArr(dataArr: NSArray) -> [User] {
        var dataList = [User]()
        
        for item in dataArr {
            if let itemData = User(item as! JSON){
                dataList.append(itemData)
            }
        }
        
        return dataList
    }
    
    init?(_ json: JSON) {
        status = "status" <~~ json
        msg = "msg" <~~ json
        if let data = json["users"] {
            self._users = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}

