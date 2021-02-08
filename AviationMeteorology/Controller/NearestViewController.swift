//
//  NearestViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 5.02.2021.
//

import UIKit
import CoreLocation

class NearestViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var locationManager = CLLocationManager()
    var sliderValue = 10
    var aviationAppData = AviationAppData()
    var nearestAirportModel = [NearestAirportModel]()
    var nearestScreenModel = [NearestScreenLoadModel]()
    var startingSettings :Dictionary<String,String> = [:]
  
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        aviationAppData.delegate = self
        locationManager.requestWhenInUseAuthorization()
        tableView.rowHeight = 200
        
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        sliderValue = Int(sender.value / 10) * 10
        distanceLabel.text = " \(String(sliderValue)) miles"
    }
    
    
    @IBAction func searchButtonPressed(_ sender:UIButton){
        locationManager.requestLocation()
        loadSettings()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            aviationAppData.nearestRequest(lat, lon, sliderValue)
            
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func loadSettings(){
        let url = Bundle.main.url(forResource: "Settings", withExtension: "plist")
        guard  let _url = url else {
            return
        }
        guard let settings = NSDictionary(contentsOf: _url) as? Dictionary<String,String> else {return}
        startingSettings = settings
    }

}
extension NearestViewController: AviationAppDelegate{
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
        nearestAirportModel = nearestAirportArray
        for singleModel in nearestAirportModel{
            nearestScreenModel.append(NearestScreenLoadModel(nearestModel: singleModel, startingSettings:startingSettings))
        }
        tableView.reloadData()
    }
    
    //    Both informations are not used here
    func updateMetar(weatherMetarArray: [WeathearMetarModel]) {
    }
    func updateTaf(weatherTafArray: [WeatherTafModel]) {
    }
}
extension NearestViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearestAirportModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: K.NearestCellid, for: indexPath) as? NearestAirportCell{
            let airportInfos = nearestScreenModel[indexPath.row].loadData()
            cell.nameLabel.text = airportInfos[K.airportName]
            cell.iataLabel.text = airportInfos[K.iata]
            cell.icaoLabel.text = airportInfos[K.icao]
            cell.bearingLabel.text = airportInfos[K.bearing]
            if let latitude = airportInfos[K.latitude], let longitude = airportInfos[K.longitude]{
                cell.coordinateLbel.text = "\(latitude) \(longitude)"
            }
            cell.timeZoneLabel.text = airportInfos[K.timeZone]
            cell.distanceLabel.text = airportInfos[K.radius]
            if let city = airportInfos[K.city], let country = airportInfos[K.country]{
                cell.cityCountryLabel.text = "\(city)    \(country)"
            }
            cell.operationalConditionLabel.text = airportInfos[K.status]
            
            let rotate = nearestAirportModel[indexPath.row].bearing

            return cell
        }
        
        return UITableViewCell()
    }
    
    
   
    
}
