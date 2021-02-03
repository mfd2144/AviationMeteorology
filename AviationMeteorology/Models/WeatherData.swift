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
    func updateMetar(weatherMetarArray: [WeathearMetarModel])
    func updateTaf(weatherTafArray :[WeatherTafModel])
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
    func weatherSource(codesICAO: [String],reportType: String){
        
        
        
        
        fetchData(codesICAO,reportType){ (dataJSON,error) in
            if let error = error{
                print(error.localizedDescription)
            }
            //           Check JSON  then parse data from other components.And data is also JSON and include our weather model informations. Then again parse it and create an array which include WeatherMetarModel
            
            if let metarTafData = dataJSON{
                for (string,metarTaf) in metarTafData{
                    if string == "data"{
                        if let metarTafArray = metarTaf.array{
                            if metarTafArray != [] && reportType == K.metar{
                                var modelMetar: [WeathearMetarModel] = []
                                for singleMetar in metarTafArray{
                                    let newModel = WeathearMetarModel.init(data: singleMetar)
                                    modelMetar.append(newModel)
                                }
                                    
                                delegate?.updateMetar(weatherMetarArray: modelMetar)
                                    }else if  metarTafArray != [] && reportType == K.taf{
                                        var modelTaf : [WeatherTafModel] = []
                                        for singleTaf in metarTafArray{
                                            let newModel = WeatherTafModel.init(data: singleTaf)
                                            modelTaf.append(newModel)
                                    }
                                        delegate?.updateTaf(weatherTafArray: modelTaf)
                                        
                                }
                                    
                            }
                        
                        }
                    }
                }
            }
            
        }
     
        
        //Fetch data using by alamofire.
        private func fetchData(_ codesICAO: [String],_ reportType: String, completion: @escaping (JSON?,Error?) -> Void){
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
    

