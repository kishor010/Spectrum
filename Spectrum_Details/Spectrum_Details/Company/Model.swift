//
//  Model.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import SwiftyJSONModel

struct CompanyModel {
    let name: String
    let website: String
    let logo: String
    let id: String
    let companyDescription: String
}

extension CompanyModel: JSONObjectInitializable {
    enum PropertyKey: String {
        case _id, company, website, logo, about
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        name = try object.value(for: .company)
        website = try object.value(for: .website)
        logo = try object.value(for: .logo)
        id = try object.value(for: ._id)
        companyDescription = try object.value(for: .about)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [
            .company: name,
            .website: website,
            .logo: logo,
            ._id: id,
            .about: companyDescription,
        ]
    }
}
