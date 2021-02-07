//
//  WeathearModels.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 2.02.2021.
//


import Foundation
import SwiftyJSON

class AviationApp{
    let data: JSON
    init(data: JSON) {
        self.data = data
    }
    var icao: String{
        return data["icao"].stringValue
    }
    var location: [String] {
        for (key,array) in data["location"]{
            if key == "coordinates"{
                let newArray = array.arrayObject as! [Double]
                return newArray.map{String(format: "%.4f", $0)}
            }
        }
        return ["0","0"]
    }
    var text: String{
        return data["raw_text"].stringValue
    }
    var elevation: Dictionary<String,String>{
       returnDictionary("elevation")
    }
    
    func returnDictionary(_ name: String)->Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data[name]{
            newDic[key] = value.stringValue
        }
        return newDic
    }
}




class WeathearMetarModel: AviationApp{
  
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


class WeatherTafModel: AviationApp{
}


extension AviationApp:Equatable{
    static func == (lhs: AviationApp, rhs: AviationApp) -> Bool {
        return lhs.data == rhs.data
    }
}

