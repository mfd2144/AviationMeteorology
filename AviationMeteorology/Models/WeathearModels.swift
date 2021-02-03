//
//  WeathearModels.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 2.02.2021.
//


import Foundation
import SwiftyJSON

struct WeathearMetarModel{
    let data : JSON
    var metarText: String{
        return data["raw_text"].stringValue
    }
    var flightCategory: String{
        return  data["flight_category"].stringValue
    }
    var temperature: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["temperature"]{
            newDic[key] = value.stringValue
        }
        return newDic
    }
    var visibility :Dictionary<String,String>{
    var  newDic = Dictionary<String,String>()
    for (key,value) in data["visibility"]{
        newDic[key] = value.stringValue
        
    }
    return newDic
}
    var clouds: String{
        return data["ceiling"]["text"].stringValue
    }
    var name: String{
        return data["station"]["name"].stringValue
        
    }
    var icao: String{
        return data["icao"].stringValue
    }
    var observedTime: String{
        let rawValue = data["observed"].stringValue
        return rawValue
    }
    var wind: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["wind"]{
            newDic[key] = value.stringValue
        }
        return newDic
    }
    var elevation:  Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["elevation"]{
            newDic[key] = value.stringValue
            
        }
        return newDic
    }
    
    var condition: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (_,value) in JSON(data["conditions"].arrayObject){
            for (_key,_value) in value{
                newDic[_key] = _value.stringValue
            }
            
        }
        return newDic
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
    var dewPoint: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["dewpoint"]{
            newDic[key] = value.stringValue
        }
        return newDic
    }

   
    var barometer: Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["barometer"]{
            newDic[key] = value.stringValue
            
        }
        return newDic
    }
    
    var ceiling:  Dictionary<String,String>{
        var  newDic = Dictionary<String,String>()
        for (key,value) in data["ceiling"]{
            newDic[key] = value.stringValue
            
        }
        return newDic
    }

    
   
    
    
    init(data: JSON){
        self.data = data
printArray()
    }
    func printArray(){
        print(barometer)
        print(elevation)
        print(wind)
        print(ceiling)
        print(dewPoint)
        print(temperature)
        print(condition)
        print(data)
    }
    
}


struct WeatherTafModel{
    let data: JSON
    var tafText :String{
        return data["raw_text"].stringValue
    }
    
    init(data:JSON){
        self.data = data
    }
}



extension WeathearMetarModel:Equatable{
    static func ==(lhs: WeathearMetarModel, rhs: WeathearMetarModel) -> Bool {
        return lhs.data == rhs.data
}

}

extension WeatherTafModel:Equatable{
    static func ==(lhs: WeatherTafModel, rhs: WeatherTafModel) -> Bool {
        return lhs.data == rhs.data
}

}
