//
//  Settings.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 14.02.2021.
//


import Foundation


struct SettingsModel: Codable {
    var elevation: String
    var temperature: String
    var wind: String
    var dewpoint: String
    var barometer: String
    var visibility: String
    var coordinates: String
    var distance: String
}



struct StartingSettings{
   
    static var startingSettingsModel: SettingsModel{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: path!)
            let startingSettings = try decoder.decode(SettingsModel.self, from: data)
            return startingSettings
        }catch{
            let defaultSettings = SettingsModel(elevation: Settings.feet.rawValue, temperature: Settings.celsius.rawValue, wind:  Settings.speed_kts.rawValue, dewpoint: Settings.celsius.rawValue, barometer: Settings.hg.rawValue, visibility: Settings.meters.rawValue, coordinates: Settings.degrees.rawValue, distance: Settings.meters.rawValue)
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(defaultSettings)
                try data.write(to: path!)
            }catch{
                print(error.localizedDescription)
            }
            return defaultSettings
        }
        
    }
}

enum Settings:String{
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
    case speed_mph = "speed_mph"
    case speed_mps = "speed_mps"
    case speed_kts = "speed_kts"
    case speed_kph = "speed_kph"
    case feet = "feet"
    case meters = "meters"
    case miles = "miles"
    case hpa = "hpa"
    case kpa = "kpa"
    case hg = "hg"
    case mb = "mb"
    case degrees = "degrees"
    case decimal = "decimal"
    
}

extension Settings{
    var info: (index: Int,abbr :String ){
        switch self {
        case .hg: return (index: 0,abbr: "Hg")
        case .hpa: return (index: 1,abbr: "hPa")
        case .kpa: return (index: 2,abbr: "kPa")
        case .mb: return (index: 3,abbr: "Mbar")
        case .feet: return (index: 0,abbr: "feet")
        case .meters: return (index: 1,abbr: "meters")
        case .miles: return (index: 0,abbr: "miles")
        case .celsius: return (index: 0,abbr: "C")
        case .fahrenheit: return (index: 1,abbr: "F")
        case .speed_mph: return (index: 0,abbr: "MPH")
        case .speed_mps: return (index: 1,abbr: "MPS")
        case .speed_kts: return (index: 2,abbr: "Knot")
        case .speed_kph: return (index: 3,abbr: "KPH")
        case .degrees: return (index: 0,abbr: "")
        case .decimal: return (index: 1,abbr: "")
        }
    }
}
