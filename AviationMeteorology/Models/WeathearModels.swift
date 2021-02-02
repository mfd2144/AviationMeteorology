//
//  WeathearModels.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 2.02.2021.
//


import Foundation
import SwiftyJSON

struct WeathearMetarModel{
     let metarText: String?
     let flightCategory: String?
     let temperature: Int?
     let visibilityMiles: String?
     let visibilityMeters: String?
     let clouds: String?
     let wind: [JSON]?
     let elevationFeet: Int?
     let elevationMeters: Int?
     let condition: String?
     let location: [Double]?
     let dewPointCelsius: Int?
     let barometer: JSON?
     let ceiling: Int?
     let name: String?
     let icao: String?
    
    init(data: JSON){

        metarText = data["raw_text"].stringValue
        flightCategory = data["flight_category"].stringValue
        temperature =  data["temperature"]["celsius"].intValue
        visibilityMiles = data["visibility"]["miles"].stringValue
        visibilityMeters = data["visibility"]["meters"].stringValue
        icao = data["icao"].stringValue
        clouds = data["ceiling"]["text"].stringValue
        ceiling = data["ceiling"]["feet"].intValue
        elevationFeet = data["flight_category"]["elevation"]["feet"].intValue
        elevationMeters = data["flight_category"]["elevation"]["meters"].intValue
        condition = data["flight_category"].stringValue
        location = data["location"]["coodinates"].arrayObject as? [Double]
        dewPointCelsius = data["flight_category"]["dewpoint"]["celsius"].intValue
        barometer = data["flight_category"]["barometer"]
        wind = data["flight_category"]["wind"].arrayValue
        name = data["flight_category"]["name"].stringValue
       
    }
    
}








