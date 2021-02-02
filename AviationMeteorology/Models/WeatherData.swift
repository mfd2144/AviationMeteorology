//
//  WeatherData.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 1.02.2021.
//

import Foundation
import SwiftyJSON
import Alamofire

enum fetchDataError: Error{
    case emptyData
}

protocol WeatherDataDelegate{
    func updateWeather(weatherArray: [WeathearMetarModel])
}

struct WeatherData{
    private let url = "https://api.checkwx.com"
    private let apiCode: String
    var delegate: WeatherDataDelegate?
    
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
    
    
    //    query for metar and taf , then grap results as JSON
    func weatherSource(codesICAO: [String]){
        
        var model: [WeathearMetarModel] = []
        fetchData(codesICAO,reportType:"metar"){ (dataJSON,error) in
            if let error = error{
                print(error.localizedDescription)
            }
            //            JSON check then parse data from other companents.And data is also JSON and include our weather model informations. Then again parse it and create an array which include WeatherMetarModel
            
            if let metarData = dataJSON{
                for (string,metar) in metarData{
                    if string == "data"{
                        if let metarArray = metar.array{
                            for singleMetar in metarArray{
                                let newModel = WeathearMetarModel.init(data: singleMetar)
                                model.append(newModel)
                            }
                            delegate?.updateWeather(weatherArray: model)
                        }
                    }
                }
            }
            
        }
        }
        
        //Fetch data
        private func fetchData(_ codesICAO: [String], reportType: String, completion: @escaping (JSON?,Error?) -> Void){
            let headars = HTTPHeader(name: "X-API-Key", value: apiCode)
            let stationsString = codeToString(codesICAO)
            print(stationsString)
            let urlString = "\(url)/\(reportType)/\(stationsString)/decoded"
            print(urlString)
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
        
    }
    

