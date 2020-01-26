//
//  DBService.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 26/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class DBService {
    
    static let sharedInstance : DBService = {
        let sharedInstance = DBService()
        return sharedInstance
    }()
    
    func fetchAllCompanies() -> [Company] {
        var listCompany = [Company]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [Company]
            if arrModels.count > 0 {
                listCompany = arrModels
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        return listCompany
    }
    
    //MARK:- Save Company and Members into DB
    func saveComapnies(data: CompanyModel) {
        var entityCompany: Company!
        if let model = checkCompanyExist(id: data.id)  {
            entityCompany = model
        }
        
        else {
            entityCompany = Company.init(context: AppDelegate.getContext())
            entityCompany.isFav = data.isFav
            entityCompany.isFollow = data.isFollowed
        }
        
        entityCompany.id = data.id
        entityCompany.name = data.name
        entityCompany.companyDescription = data.companyDescription
        entityCompany.logo = data.logo
        entityCompany.website = data.website
        
        self.saveContext()
    }
    
    func saveMembers(data: MemberModel, companyId: String)  {
        var entityMember: Member!
        if let model = checkMemberExist(id: data.id)  {
            entityMember = model
        }
        
        else {
            entityMember = Member.init(context: AppDelegate.getContext())
        }
        
        entityMember.id = data.id
        entityMember.company_id = companyId
        entityMember.age = Int32(data.age)
        entityMember.isFav = false
        //entityMember.name = data.name
        entityMember.email = data.email
        entityMember.phone = data.phone
        
        self.saveContext()
    }
    
    //MARK:- Check if any Company is present or not.
    fileprivate func checkCompanyExist(id: String?) -> Company? {
        var model: Company?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        fetchRequest.predicate = NSPredicate(format: "id == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [Company]
            
            if arrModels.count > 0 {
                model = arrModels[0]
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        return model
    }
    
    //MARK:- Check if any Member is present or not.
    fileprivate func checkMemberExist(id: String?) -> Member? {
        var model: Member?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
        fetchRequest.predicate = NSPredicate(format: "id == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [Member]
            
            if arrModels.count > 0 {
                model = arrModels[0]
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        return model
    }
    
    func markFavAndUnFavCompany(companyId: String, isFav: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        fetchRequest.predicate = NSPredicate(format: "id == %@ ", companyId)
        do {
            let companies = try AppDelegate.getContext().fetch(fetchRequest) as! [Company]
            
            if companies.count > 0 {
                companies[0].isFav = isFav
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        self.saveContext()
    }
    
    func markFollowAndUnFollowCompany(companyId: String, isFollow: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        fetchRequest.predicate = NSPredicate(format: "id == %@ ", companyId)
        do {
            let companies = try AppDelegate.getContext().fetch(fetchRequest) as! [Company]
            
            if companies.count > 0 {
                companies[0].isFollow = isFollow
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        self.saveContext()
    }
    
    //MARK:- Save Context
    func saveContext() {
        do {
            try AppDelegate.getContext().save()
        }
            
        catch let contextError {
            //Error
            print(contextError as AnyObject)
        }
    }
}
