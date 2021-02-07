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
        distanceLabel.text = String(sliderValue)
    }
    
    
    @IBAction func searchButtonPressed(_ sender:UIButton){
        locationManager.requestLocation()
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
    func nearestScreenLoadModel(index: Int){
        let name = nearestAirportModel[index].name
        let status = nearestAirportModel[index].status
        let type = nearestAirportModel[index].type
        let iata = nearestAirportModel[index].iata
        let city = nearestAirportModel[index].city
        let icao = nearestAirportModel[index].icao
        
    }
}
extension NearestViewController: AviationAppDelegate{
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
        nearestAirportModel = nearestAirportArray
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
            cell.nameLabel.text = nearestAirportModel[indexPath.row].name
            let rotate = nearestAirportModel[indexPath.row].bearing
            cell.bearingLabel.text = String(rotate)
            if rotate != 0{
                let val = .pi/(CGFloat(rotate)/180.0)
                cell.arrowImage.transform = cell.arrowImage.transform.rotated(by: val)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    
}

