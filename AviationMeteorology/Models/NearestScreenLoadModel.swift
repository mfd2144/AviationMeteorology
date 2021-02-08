//
//  NearestScreenLoadModel.swift
//  AviationMeteorology
//  It takes model from nearest page, also from settings page and turn back information array to help fill the labels with measure identity aabrevations.
//  This page decide to which settings use in user nearest page.
//  Created by Mehmet fatih DOĞAN on 8.02.2021.
//

import Foundation


struct NearestScreenLoadModel {
    private let nearestModel: NearestAirportModel
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
    
    init(nearestModel: NearestAirportModel,startingSettings: Dictionary<String,String>){
        self.nearestModel = nearestModel
        self.startingSettings = startingSettings
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
        let latitude = collectData(data: nearestModel.latitude[startingSettings[K.coordinates]!])
        let longitude = collectData(data: nearestModel.longitude[startingSettings[K.coordinates]!])
        let radiusDistance = collectData(data: nearestModel.radius[startingSettings[K.visibility]!])
        let bearing = collectData(data: String(nearestModel.bearing))
       
       
       
                    
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
            K.longitude:longitude
            
        ]
        return values
}
}
