//
//  SunTimesModel.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 9.02.2021.
//

import Foundation
import SwiftyJSON

class SunTimesModel: AviationApp{
    var civil_dawn_utc :String{
        return data["sunrise_sunset"]["utc"]["civil_dawn"].stringValue
    }
    var civil_dusk_utc :String{
        return data["sunrise_sunset"]["utc"]["civil_dusk"].stringValue
    }
    var sun_rise_utc :String{
        return data["sunrise_sunset"]["utc"]["sun_rise"].stringValue
    }
    var sun_set_utc :String{
        return data["sunrise_sunset"]["utc"]["sun_set"].stringValue
    }
    var civil_dawn_local :String{
        return data["sunrise_sunset"]["local"]["civil_dawn"].stringValue
    }
    var civil_dusk_local :String{
        return data["sunrise_sunset"]["local"]["civil_dusk"].stringValue
    }
    var sun_rise_local :String{
        return data["sunrise_sunset"]["local"]["sun_rise"].stringValue
    }
    var sun_set_local :String{
        return data["sunrise_sunset"]["local"]["sun_set"].stringValue
    }
 
    
}
