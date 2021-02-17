//
//  File.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 16.02.2021.
//

import Foundation
import SwiftyJSON


// fetch data and create some same data for metar,taf and suntimes models.
class AviationAppModel{
    
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


