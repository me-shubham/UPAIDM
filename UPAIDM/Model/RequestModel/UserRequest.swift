//
//  UserRequest.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import Foundation
import Gloss

class UserRequest: Encodable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var countryCode: String?
    var phoneNumber: String?
    var password: String?
    var latitude: Double?
    var longitude: Double?
    
    func toJSON() -> JSON? {
        return jsonify([
            "firstName" ~~> self.firstName,
            "lastName" ~~> self.lastName,
            "email" ~~> self.email,
            "countryCode" ~~> self.countryCode,
            "phoneNumber" ~~> self.phoneNumber,
            "password" ~~> self.password,
            "latitude" ~~> self.latitude,
            "longitude" ~~> self.longitude
            ])
    }
}
