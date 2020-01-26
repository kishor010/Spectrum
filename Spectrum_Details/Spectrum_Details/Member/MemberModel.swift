//
//  MemberModel.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import SwiftyJSONModel

/*struct name: JSONObjectInitializable{
    var firstName: String
    var lastName: String
    
    enum PropertyKey: String {
        case first, last
    }
    
    init(object: JSONObject<Self.PropertyKey>) throws {
        firstName = try object.value(for: .first)
        lastName = try object.value(for: .last)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .first: firstName,
            .last: lastName,
        ]
    }
}*/

struct name {
    var firstName: String
    var lastName: String
    
    init(first: String, last: String) {
        self.firstName = first
        self.lastName = last
    }
}

struct MemberModel {
    let age: Int
    let email: String
    let id: String
    var nameData = name.init(first: "", last: "")
    let phone: String
}

extension MemberModel: JSONObjectInitializable {
    enum PropertyKey: String {
        case _id, age, name, email, phone, first, last
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        
        nameData.firstName = try object.value(for: .first)
        nameData.lastName = try object.value(for: .last)
        age = try object.value(for: .age)
        email = try object.value(for: .email)
        id = try object.value(for: ._id)
        phone = try object.value(for: .phone)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .first: nameData.firstName,
            .last: nameData.lastName,
            .age: age,
            ._id: id,
            .email: email,
            .phone: phone,
        ]
    }
}
