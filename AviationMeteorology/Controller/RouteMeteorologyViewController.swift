//
//  ViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 9.02.2021.
//

import UIKit

class RouteMeteorologyViewController: UIViewController {
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var metarModel : [WeathearMetarModel]?
    var tafModel : [WeatherTafModel]?
    var aviationAppData = AviationAppData()
    var routeModel: [RouteModel]?
    var tafLogic: Bool = false
    var metarLogic: Bool = false
    var selectedSection: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        aviationAppData.delegate = self
        tableView.rowHeight = 70

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func buttonPressed(_ sender: UIButton){
        let codesArray : [String] = [textField1.text!, textField2.text!,textField3.text!, textField4.text!, textField5.text!,textField6.text!]
        let set = Set(codesArray)
        let codes = Array(set)
        aviationAppData.weatherRequest(codesICAO: codes, reportType: K.metar)
        aviationAppData.weatherRequest(codesICAO: codes, reportType: K.taf)
    }
    
    
    func createNewTafMetarUnionModel(){
        if metarLogic && tafLogic{
            routeModel = nil
            guard let metarArray = metarModel, let tafArray = tafModel else {return}
            for tafItem in tafArray{
                //   first we start wandering in the tafs
                var checklogic = false
                for metarItem in metarArray{
                    //   then for every piece of taf we looking same metar data and create new route model
                    
                    if tafItem.icao == metarItem.icao{
                        let newRouteModel = RouteModel(icao: metarItem.icao, metar: metarItem.text, taf: tafItem.text, metarModel:metarItem )
                        checklogic = true
                        
//         this part let us append new information in route model otheerwise(use append directly) its value doesn't change(nil)
                        if routeModel != nil{
                            routeModel!.append(newRouteModel)
                        }else{
                            routeModel = [newRouteModel]
                        }
                        
                    }
                }
//                some airport doesn't have metar information, if we don't find any metar this part just add taf in pour model
                if !checklogic{
                    let newRouteModel = RouteModel(icao: tafItem.icao, metar:nil, taf: tafItem.text, metarModel:nil )
                    if routeModel != nil{
                        routeModel!.append(newRouteModel)
                    }else{
                        routeModel = [newRouteModel]
                    }
                }
            }
            
            metarLogic = false
            tafLogic = false
            tableView.reloadData()
        }
        
        
    }
    
    
}


extension RouteMeteorologyViewController: AviationAppDelegate{
    func updateMetar(weatherMetarArray: [WeathearMetarModel], logic: Bool) {
        metarModel = weatherMetarArray
        metarLogic = logic
        createNewTafMetarUnionModel()
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel], logic: Bool) {
        tafModel = weatherTafArray
        tafLogic = logic
        createNewTafMetarUnionModel()
    }

    //    be empty
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
    }
    func updatenearest(sunTimesModel: SunTimesModel) {
    }
}



extension RouteMeteorologyViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return routeModel?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let route = routeModel?[section]{
            return route.metar != nil ? 2 : 1
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let route = routeModel?[section]{
            return route.icao
        }
        else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.routecellIdentification, for: indexPath) as! RouteTableViewCell
        if indexPath.row == 0{
            cell.resultLabel.text = routeModel![indexPath.section].taf
            
        }else{
            cell.resultLabel.text = routeModel![indexPath.section].metar
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if ((routeModel?[indexPath.section].metarModel) != nil) && indexPath.row == 1{
            selectedSection = indexPath.section
            performSegue(withIdentifier: K.routeToDetailIdentification, sender: self)
        
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! DecodedMetarViewController
        if let model = routeModel?[selectedSection!].metarModel  {
            destinationVC.weatherModel = model
        }
       
    }

}
