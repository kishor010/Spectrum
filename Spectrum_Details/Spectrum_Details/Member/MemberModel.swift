//
//  MemberModel.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import SwiftyJSONModel

struct MemberModel {
    let age: Int
    let email: String
    let company_id: String
    let id: String
    let name: String
    let phone: String
}

extension MemberModel: JSONObjectInitializable {
    enum PropertyKey: String {
        case _id, age, name, email, phone
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        name = try object.value(for: .name)
        age = try object.value(for: .age)
        email = try object.value(for: .email)
        id = try object.value(for: ._id)
        phone = try object.value(for: .phone)
        company_id = try object.value(for: ._id)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .name: name,
            .age: age,
            ._id: id,
            .email: email,
            .phone: phone,
        ]
    }
}
