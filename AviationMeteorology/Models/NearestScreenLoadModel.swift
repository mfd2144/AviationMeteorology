//
//  NearestScreenLoadModel.swift
//  AviationMeteorology
//  It takes model from nearest page, also from settings page and turn back information array to help fill the labels with measure identity aabrevations.
//  This page decide to which settings use in user nearest page.
//  Created by Mehmet fatih DOĞAN on 8.02.2021.
//  same logic in decoded screen load model

import Foundation


struct NearestScreenLoadModel {
    private let nearestModel: NearestAirportModel
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
    
    init(nearestModel: NearestAirportModel){
        self.nearestModel = nearestModel
    }
    
    
    private func collectData(data: String?,_ constantName: String? = nil)->String{
//       it help grasp data safetly, add measure abbrevations and if string value is empty return dash
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
        let name = collectData(data: nearestModel.name)
        let status = collectData(data: nearestModel.status)
        let country = collectData(data: nearestModel.country)
        let city = collectData(data: nearestModel.city)
        let type = collectData(data: nearestModel.type)
        let iata = collectData(data: nearestModel.iata)
        let icao = collectData(data: nearestModel.icao)
        let timeZone = collectData(data: nearestModel.timeZone)
        let latitude = collectData(data: nearestModel.latitude[actualSettings.coordinates])
        let longitude = collectData(data: nearestModel.longitude[actualSettings.coordinates])
        let radiusDistance = collectData(data: nearestModel.radius[actualSettings.distance])
        let bearing = collectData(data: String(nearestModel.bearing))
        let elevation = collectData(data: nearestModel.elevation[actualSettings.elevation],K.elevation)
              
        let values = [
            K.airportName:name,
            K.status:status,
            K.city:city,
            K.country:country,
            K.timeZone:timeZone,
            K.icao:icao,
            K.iata:iata,
            K.type:type,
            K.bearing:bearing,
            K.radius:radiusDistance,
            K.latitude:latitude,
            K.longitude:longitude,
            K.elevation:elevation
            
        ]
        return values
}
}
