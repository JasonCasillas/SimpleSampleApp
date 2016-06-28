//
//  UserMappable.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit
import ObjectMapper

class UserMappable: Mappable {

    var id: NSNumber!
    var username: String?
    var email: String?
    var phone: String?
    var website: String?
    var addressStreet: String?
    var addressSuite: String?
    var addressCity: String?
    var addressZipcode: String?
    var addressLatitude: String?
    var addressLongitude: String?
    var companyName: String?
    var companyCatchPhrase: String?
    var companyBS: String?

    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        email <- map["email"]
        phone <- map["phone"]
        website <- map["website"]
        addressStreet <- map["address.street"]
        addressSuite <- map["address.suite"]
        addressCity <- map["address.city"]
        addressZipcode <- map["address.zipcode"]
        addressLatitude <- map["address.geo.lat"]
        addressLongitude <- map["address.geo.lng"]
        companyName <- map["company.name"]
        companyCatchPhrase <- map["company.catchPhrase"]
        companyBS <- map["company.bs"]
    }
}
