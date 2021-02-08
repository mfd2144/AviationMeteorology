//
//  File.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 6.02.2021.
//

import Foundation             
import SwiftyJSON

class NearestAirportModel:AviationApp{
    var name: String{
        return data["name"].stringValue
    }
    var status: String{
        return data["status"].stringValue
    }
    var country: String{
        return data["country"]["name"].stringValue
    }
    var type: String{
        return data["type"].stringValue
    }
    var iata: String{
        return data["iata"].stringValue
    }
    var latitude: Dictionary<String,String>{
        returnDictionary("latitude")
    }
    var longitude: Dictionary<String,String>{
        returnDictionary("longitude")
    }
    var city: String{
        return data["city"].stringValue
    }
    var timeZone: String{
        return data["timezone"]["zone"].stringValue
    }
    var radius: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["radius"]{
            if key == "miles" {
                newDic[key] = "\(String(format: "%.3f", value.doubleValue)) Miles"
            }else if key == "meters"{
                newDic[key] = "\(value.doubleValue/1000) Km"
            }
        }
        return newDic
    }
    var bearing: Int{
        return data["radius"]["bearing"].intValue
    }
    

}
