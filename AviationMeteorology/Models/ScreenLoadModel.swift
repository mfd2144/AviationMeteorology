//
//  File.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 5.02.2021.
//

import Foundation

struct ScreenLoadModel {
    private let weatherModel: WeathearMetarModel
    private let startingSettings: Dictionary<String,String>
    
    private var settingsWithAbbr: Dictionary<String,String>{
        var abbr =  Dictionary<String,String>()
        for item in startingSettings.enumerated(){
            if let settings = Settings.init(rawValue: item.element.value){
                abbr[item.element.key] = settings.info.abbr
            }
        }
        return abbr
    }
    
    init(weatherModel: WeathearMetarModel,startingSettings: Dictionary<String,String>){
        self.weatherModel = weatherModel
        self.startingSettings = startingSettings
    }
    
    
    private func collectData(data: String?,_ constantName: String? = nil)->String{
//       it help grasp data safetly, add abbrevations and if string value is empty return dash
        if let dataString = data {
            if let abbr = settingsWithAbbr[constantName ?? ""]{
                return "\(dataString) \(abbr)"
            }
            return dataString
        }
        return "-"
    }
    
    
    func loadData()->Dictionary<String,String>{
        let name = collectData(data: weatherModel.name)
        let ceiling = collectData(data: weatherModel.ceiling[startingSettings[K.elevation]!],K.elevation)
        let cloudName = collectData(data: weatherModel.clouds)
        let flightRule = collectData(data: weatherModel.flightCategory)
        let time = collectData(data: weatherModel.observedTime)
        let visibility = collectData(data: weatherModel.visibility[startingSettings[K.visibility]!],K.visibility)
        let condition = collectData(data: weatherModel.condition["text"] )
        let dewpoint = collectData(data: weatherModel.dewPoint[startingSettings[K.temperature]!], K.temperature)
        let wind = collectData(data: weatherModel.wind[startingSettings[K.wind]!], K.wind)
        let barometer = collectData(data: weatherModel.barometer[startingSettings[K.barometer]!], K.barometer)
        let temperature  = collectData(data: weatherModel.temperature[startingSettings[K.temperature]!], K.temperature)
        let elevation = collectData(data: weatherModel.elevation[startingSettings[K.elevation]!])
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
