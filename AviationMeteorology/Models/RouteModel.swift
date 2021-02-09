//
//  RouteModel.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 9.02.2021.
//

import Foundation



struct RouteModel{
    let icao: String
    let metar: String?
    let taf: String?
    let metarModel: WeathearMetarModel?
}
