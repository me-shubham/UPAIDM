//
//  User.swift
//  u-paid-m
//
//  Created by Srajansinghal on 27/11/20.
//

import UIKit
import Gloss

final class User: Decodable {
    
    var _id: String?
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var countryCode: String?
    var password: String?
    var status: Bool?
    var msg: String?
    var latitude: Double?
    var longitude: Double?
    var role: Int?
    var __v: Double?
    var firebasetoken: String?
    private var _invoiceData: [Invoice]?
    var invoiceData: [Invoice]?{
        return _invoiceData
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
        _id = "_id" <~~ json
        userId = "userId" <~~ json
        firstName = "firstName" <~~ json
        lastName = "lastName" <~~ json
        email = "email" <~~ json
        phoneNumber = "phoneNumber" <~~ json
        password = "password" <~~ json
        status = "status" <~~ json
        msg = "msg" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        role = "role" <~~ json
        countryCode = "countryCode" <~~ json
        __v = "__v" <~~ json
        firebasetoken = "firebasetoken" <~~ json
        if let data = json["invoiceData"] {
            self._invoiceData = getDataFromArr(dataArr: data as? NSArray ?? NSArray())
        }
    }

}
