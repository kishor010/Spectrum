//
//  DBService.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 26/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation
import CoreData

class DBService {
    
    static let sharedInstance : DBService = {
        let sharedInstance = DBService()
        return sharedInstance
    }()
    
    /*//MARK:- Save Rate Conversion Details into DB
    func save(arrRateConverter: [RateConverterModel]) {
        for itemModel in arrRateConverter {
            var entityRC: RateConversion!
            if let model = getRateConverter(id: itemModel.serachRatesKey) {
                entityRC = model
            }
            
            else {
                entityRC = RateConversion.init(context: AppDelegate.getContext())
                entityRC.serachRatesKey = itemModel.serachRatesKey
            }
            entityRC.countryCodeFrom = itemModel.countryCodeFrom
            entityRC.countryCodeTo = itemModel.countryCodeTo
            entityRC.countryNameFrom = itemModel.countryNameFrom
            entityRC.countryNameTo = itemModel.countryNameTo
            entityRC.rate = itemModel.rate
            
            self.saveContext()
        }
    }
    
    //MARK:- Check if any rate converter model is present or not.
    fileprivate func getRateConverter(id: String?) -> RateConversion? {
        var model: RateConversion?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RateConversion")
        fetchRequest.predicate = NSPredicate(format: "serachRatesKey == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RateConversion]
            
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


//MARK:- Quiz Information fetch from Core Data
extension DBService {
    func fetchRCModel() -> [RateConverterModel]  {
        var arrRCModel: [RateConversion] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RateConversion")
        do {
            arrRCModel = try AppDelegate.getContext().fetch(fetchRequest) as! [RateConversion]
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        return convertDBIntoModel(arrRCDBModel: arrRCModel)
    }
    
    fileprivate func convertDBIntoModel(arrRCDBModel: [RateConversion]) -> [RateConverterModel] {
        
        if arrRCDBModel.count > 0 {
            var arrModelRC = [RateConverterModel]()
            for item in arrRCDBModel {
                let modelItem =  RateConverterModel.init(countryCodeFrom: item.countryCodeFrom, countryCodeTo: item.countryCodeTo, countryNameFrom: item.countryNameFrom, countryNameTo: item.countryNameTo, serachRatesKey: item.serachRatesKey, rate: item.rate)
                arrModelRC.append(modelItem)
            }
            return arrModelRC
        }
        else {
            return []
        }
    }
}

//MARK:- Quiz Information Delete from Core Data
extension DBService {
    func deleteRateConverter(id: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RateConversion")
        fetchRequest.predicate = NSPredicate(format: "serachRatesKey == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RateConversion]
            for obj in arrModels {
                AppDelegate.getContext().delete(obj)
            }
            self.saveContext()
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
    }*/
}
