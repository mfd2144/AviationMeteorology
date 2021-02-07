//
//  WeatherData.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 1.02.2021.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation


enum fetchDataError: Error{
    case emptyData
}

protocol AviationAppDelegate {
    func updateMetar(weatherMetarArray: [WeathearMetarModel])
    func updateTaf(weatherTafArray :[WeatherTafModel])
}

struct AviationAppData{
    private let url = "https://api.checkwx.com"
    private let apiCode: String
    var delegate: AviationAppDelegate?
    
    //Api code has been hid in plist
    init() {
        let bundle = Bundle.main.url(forResource: "ApiCode", withExtension: "plist")
        let inventory = NSDictionary(contentsOf: bundle!)
        apiCode = inventory?.value(forKey: "ApiCode") as! String
    }
    
    
    //    convert array to sting which devided by comma and check it
    private func codeToString(_ icaoCodes: [String])->String{
        var codes = String()
        for icao in icaoCodes{
            if icao != "" && icao.count == 4{
                codes += "\(icao),"
            }
        }
        return codes
    }
    
    
    
    //Fetch data using by alamofire.
    private func fetchJSONData(_ urlString: String, completion: @escaping (JSON?,Error?) -> Void){
        let headars = HTTPHeader(name: "X-API-Key", value: apiCode)
        //        alamofire get request
        AF.request(urlString,method: .get,headers: [headars]).responseJSON { (response) in
            do{
                let data = try JSON(response.result.get())
                completion(data,nil)
                
            }catch{
                completion(nil,error)
            }
        }
        //        when there isn't any data
        completion(nil,fetchDataError.emptyData)
    }
    
    
    
    
    //MARK: - Take user request about airports meteorology and respond
    func weatherRequest(codesICAO: [String],reportType: String){
        let stationsString = codeToString(codesICAO)
        let urlString = "\(url)/\(reportType)/\(stationsString)/decoded"
        fetchJSONData(urlString) { (json, error) in
            if let _error = error{
                print(_error.localizedDescription)
            }
            if let _json = json{
                weatherDataResult(_json,reportType)
            }
        }
    }
    
    //    Take JSON parse it and convert to WeatherModel then thanks to delegate send WeatherData as a response
    private func weatherDataResult(_ json:JSON, _ reportType:String){
        for (string,metarTaf) in json{
            if string == "data"{
                if let metarTafArray = metarTaf.array{
                    if metarTafArray != [] && reportType == K.metar{
                        var modelMetar = [WeathearMetarModel]()
                        modelMetar.append(contentsOf: metarTafArray.map({WeathearMetarModel.init(data: $0)}))
                        delegate?.updateMetar(weatherMetarArray: modelMetar)
                    }else if  metarTafArray != [] && reportType == K.taf{
                        var modelTaf = [WeatherTafModel]()
                        modelTaf.append(contentsOf: metarTafArray.map({WeatherTafModel.init(data: $0)}))
                        delegate?.updateTaf(weatherTafArray: modelTaf)
                    }
                }
            }
        }
    }
    
    //MARK: - Take user request about nearest airports information and respond
    func nearestRequest(_ lat: CLLocationDegrees,_ lon: CLLocationDegrees, _ radius: Int){
        let urlString =  "\(url)/station/lat/\(lat)/lon/\(lon)/radius/\(radius)"
        fetchJSONData(urlString) { (json, error) in
            if let _error = error{
                print(_error.localizedDescription)
            }
            if let _json = json{
                nearestDataResult(_json)
            }
        }
    }
    
    private func nearestDataResult(_ json:JSON){
        for (key,value) in json{
            if key == "data"{
                if let nearestJSON = value.array{
                    var nearestModel = [NearestAirportModel]()
                    nearestModel.append(contentsOf: nearestJSON.map({NearestAirportModel.init(data: $0)}))
                }
            }
        }
    }
    
    
}




