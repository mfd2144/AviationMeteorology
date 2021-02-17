//
//  WeathearModels.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 2.02.2021.
//


import Foundation
import SwiftyJSON


class WeathearMetarModel: AviationAppModel{
  
    let weatherSettings = UnitsSettingTableViewController()
    
   
    var flightCategory: String{
        return  data["flight_category"].stringValue
    }
    var temperature: Dictionary<String,String>{
        returnDictionary("temperature")
    }
    var visibility :Dictionary<String,String>{
        returnDictionary("visibility")
    }
    var clouds: String{
        return data["ceiling"]["text"].stringValue
    }
    var name: String{
        return data["station"]["name"].stringValue
        
    }
   
    var observedTime: String{
        let rawValue = data["observed"].stringValue
        return rawValue
    }
    var wind: Dictionary<String,String>{
   returnDictionary("wind")
    }
    
    
    var condition: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (_,value) in JSON(data["conditions"].arrayObject as Any){
            for (_key,_value) in value{
                newDic[_key] = _value.stringValue
            }
        }
        return newDic
    }
  
    var dewPoint: Dictionary<String,String>{
        returnDictionary("dewpoint")
    }
    var barometer: Dictionary<String,String>{
    returnDictionary("barometer")
    }
    
    var ceiling:  Dictionary<String,String>{
       returnDictionary("ceiling")
    }
  

    
}


class WeatherTafModel: AviationAppModel{
}


extension AviationAppModel:Equatable{
    static func == (lhs: AviationAppModel, rhs: AviationAppModel) -> Bool {
        return lhs.data == rhs.data
    }
}

