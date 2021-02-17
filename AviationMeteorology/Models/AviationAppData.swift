//
//  WeatherData.swift
//  AviationMeteorology
//  All requests and data fetch processes take place here
//  Created by Mehmet fatih DOĞAN on 1.02.2021.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

//this protocol allows data returning concerning pages and also send error information.
protocol AviationAppDelegate {
    func updateMetar(weatherMetarArray: [WeathearMetarModel]?,logic: Bool)
    func updateTaf(weatherTafArray :[WeatherTafModel]?,logic: Bool)
    func updatenearest(nearestAirportArray : [NearestAirportModel])
    func updatenearest(sunTimesModel: SunTimesModel)
    func errorDidThrow(error: Error)
}


//All data request takes place in this struct
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
    
    
    
//Fetch data using by alamofire.All model first create a url then activate this function and grap the results.And thanks to protocol all data send back.
    private func fetchJSONData(_ urlString: String, completion: @escaping (JSON?,Error?) -> Void){
        let headars = HTTPHeader(name: "X-API-Key", value: apiCode)
        AF.request(urlString,method: .get,headers: [headars]).responseJSON { (response) in
            do{
                let data = try JSON(response.result.get())
                completion(data,nil)
            }catch{
                completion(nil,error)
                
            }
        }
    }
    
    
    
    
    //MARK: - Take user request about airports meteorology and respond
    func weatherRequest(codesICAO: [String],reportType: String){
        let stationsString = codeToString(codesICAO)
        let urlString = "\(url)/\(reportType)/\(stationsString)/decoded"
        fetchJSONData(urlString) { (json, error) in
            if let _error = error{
                delegate?.errorDidThrow(error: _error)
            }
            if let _json = json{
                weatherDataResult(_json,reportType)
            }
        }
    }
    
    //    Take JSON parse it and convert to WeatherModel then thanks to delegate send WeatherData as a response.Also I use logic variable because in somepart in my program I need to seperate is data true(it have value) ,false(it came back but there isn't any data) or nil (still in process)
    private func weatherDataResult(_ json:JSON, _ reportType:String){
        for (string,metarTaf) in json{
            if string == "data"{
                if let metarTafArray = metarTaf.array{
//  Seperating metar data from taf data in this part
                    if metarTafArray != [] && reportType == K.metar{
                        var modelMetar = [WeathearMetarModel]()
                        modelMetar.append(contentsOf: metarTafArray.map({WeathearMetarModel.init(data: $0)}))
                        let logic = true
                        delegate?.updateMetar(weatherMetarArray: modelMetar,logic:logic)
                    }else if  metarTafArray != [] && reportType == K.taf{
                        var modelTaf = [WeatherTafModel]()
                        modelTaf.append(contentsOf: metarTafArray.map({WeatherTafModel.init(data: $0)}))
                        let logic = true
                        delegate?.updateTaf(weatherTafArray: modelTaf,logic: logic)
                    }else{
                        reportType == K.taf ? delegate?.updateTaf(weatherTafArray: nil, logic: false) : delegate?.updateMetar(weatherMetarArray: nil, logic: false)
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
                delegate?.errorDidThrow(error: _error)
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
                    delegate?.updatenearest(nearestAirportArray: nearestModel)
                }
            }
        }
    }
    
    //MARK: - Take user request about suntimes information and respond
    func sunTimesAirport(icao: String){
        let urlString =  "\(url)/station/\(icao)/suntimes"

        fetchJSONData(urlString) { (json, error) in
            if let _error = error{
                print("3")
                delegate?.errorDidThrow(error: _error)
            }
            if let _json = json{
                print("77")
                print(_json)
                sunTimesDataResult(_json)
                
            }
        }

    }
    private func sunTimesDataResult(_ json:JSON){
        for (key,value) in json{
            if key == "data"{
                if let sunTimesJSON = value.array?.first{
                    let model = SunTimesModel.init(data: sunTimesJSON)
                    delegate?.updatenearest(sunTimesModel: model)
                }
            }
        }
    }
    //MARK: - User Alert
//    this function helps the decrease code 
    func userAlert(sender:UIViewController,message: String){
        let alert = UIAlertController(title: "", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel){_ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }
    
}




