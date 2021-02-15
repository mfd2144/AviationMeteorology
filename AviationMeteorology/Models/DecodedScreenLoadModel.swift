//
//  File.swift
//  AviationMeteorology
//  It takes model from decoded page, also from settings page and turn back information array to help fill the labels with measure identity abbrevations.
//  This page decide to which settings use in user decoded page.
//  Created by Mehmet fatih DOĞAN on 5.02.2021.
//

import Foundation

struct DecodedScreenLoadModel {
    private let weatherModel: WeathearMetarModel
    private let actualSettings: SettingsModel = StartingSettings.startingSettingsModel
    
    private var settingsWithAbbr: Dictionary<String,String>{
        let abbr = [
            K.barometer:actualSettings.barometer,
            K.wind:actualSettings.wind,
            K.dewpoint:actualSettings.dewpoint,
            K.coordinates:actualSettings.coordinates,
            K.distance:actualSettings.distance,
            K.elevation:actualSettings.elevation,
            K.visibility:actualSettings.visibility,
            K.temperature:actualSettings.temperature
        ]
        return abbr
    }
    
    init(weatherModel: WeathearMetarModel){
        self.weatherModel = weatherModel
    }
    
    
    private func collectData(data: String?,_ constantName: String? = nil)->String{
//       it help grasp data safetly, add abbrevations and if string value is empty return dash
        if data != "" {
        if let dataString = data{
            if let abbr = settingsWithAbbr[constantName ?? ""]{
                return "\(dataString) \(abbr)"
            }
            return dataString
        }
        }
        return "-"
    }
    
    
    func loadData()->Dictionary<String,String>{
        let name = collectData(data: weatherModel.name)
        let ceiling = collectData(data: weatherModel.ceiling[actualSettings.elevation],K.elevation)
        let cloudName = collectData(data: weatherModel.clouds)
        let flightRule = collectData(data: weatherModel.flightCategory)
        let time = collectData(data: weatherModel.observedTime)
        let visibility = collectData(data: weatherModel.visibility[actualSettings.visibility],K.visibility)
        let condition = collectData(data: weatherModel.condition["text"] )
        let dewpoint = collectData(data: weatherModel.dewPoint[actualSettings.dewpoint], K.temperature)
        let wind = collectData(data: weatherModel.wind[actualSettings.wind], K.wind)
        let barometer = collectData(data: weatherModel.barometer[actualSettings.barometer], K.barometer)
        let temperature  = collectData(data: weatherModel.temperature[actualSettings.temperature], K.temperature)
        let elevation = collectData(data: weatherModel.elevation[actualSettings.elevation])
        let coordinatesValue =  " \(weatherModel.location.first ?? "-"), \(weatherModel.location.last ?? "-")"
                    
        let values = [
            K.airportName:name,
            K.ceiling:ceiling,
            K.cloud:cloudName,
            K.flightRule:flightRule,
            K.time:time,
            K.visibility:visibility,
            K.condition:condition,
            K.dewpoint:dewpoint,
            K.wind:wind,
            K.barometer:barometer,
            K.temperature:temperature,
            K.elevation:elevation,
            K.coordinates:coordinatesValue
        ]
        return values
}
}
