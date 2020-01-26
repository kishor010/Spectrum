//
//  CompanyViewModel.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 26/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol getCompaniesListDelegate: class {
    func success(value: Bool, data: [CompanyModel])
    func failure(error: String)
}

class CompanyViewModel: NSObject {
    weak var delegate: getCompaniesListDelegate?
    //Fetch All companies
    func fetchCompaniesList() {
        NetworkManager.sharedInstance.apiToGetCompaniesList(onSuccess: { (json) in
            let arrData = self.parseData(data: json)
            self.delegate?.success(value: true,data: arrData)
        }) { (error) in
            self.delegate?.failure(error: error)
        }
    }
    
    //Parse and save data into DB
    fileprivate func parseData(data: JSON) -> [CompanyModel] {
        var arrModel = [CompanyModel]()
        if let arrData = data.array {
            for item in arrData {
                if let modelObjCompany = try? CompanyModel.init(json: item) {
                    arrModel.append(modelObjCompany)
                    DBService.sharedInstance.saveComapnies(data: modelObjCompany)
                    if let members = item["members"].array {
                        for member in members {
                            if let modelObjMember = try? MemberModel.init(json: member) {
                                DBService.sharedInstance.saveMembers(data: modelObjMember, companyId: modelObjCompany.id)
                            }
                        }
                    }
                }
            }
        }
        return arrModel
    }
}
