//
//  NearestViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 5.02.2021.
//

import UIKit
import CoreLocation

class NearestViewController: UIViewController {
    
    
    @IBOutlet weak var findButtom: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var sliderValue = 10
    var aviationAppData = AviationAppData()
    var nearestAirportModel = [NearestAirportModel]()
    var nearestScreenModel = [NearestScreenLoadModel]()
    var startingSettings :Dictionary<String,String> = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        aviationAppData.delegate = self
        locationManager.requestWhenInUseAuthorization()
        tableView.rowHeight = 200
        findButtom.drawCorner(cornerRadius: findButtom.frame.size.height/2)
        
    }
    //    adjust radius of search
    @IBAction func distanceSlider(_ sender: UISlider) {
        sliderValue = Int(sender.value / 10) * 10
        distanceLabel.text = " \(String(sliderValue)) miles"
    }
    
    //    call the results
    @IBAction func searchButtonPressed(_ sender:UIButton){
        locationManager.requestLocation()
        loadSettings()
        
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
    
    
    func updatenearest(nearestAirportArray: [NearestAirportModel]){
        nearestAirportModel = nearestAirportArray
        for singleModel in nearestAirportModel{
            nearestScreenModel.append(NearestScreenLoadModel(nearestModel: singleModel, startingSettings:startingSettings))
        }
        tableView.reloadData()
    }
    //    Both informations are not used here
    func updateMetar(weatherMetarArray: [WeathearMetarModel]?, logic: Bool){
    }
    func updateTaf(weatherTafArray: [WeatherTafModel]?, logic: Bool){
    }
}


//MARK: - TableView Data Source and Delegate
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
            cell.bearingLabel.text = "Bearing:\(airportInfos[K.bearing]!)°"
            if let latitude = airportInfos[K.latitude], let longitude = airportInfos[K.longitude]{
                cell.coordinateLbel.text = "\(latitude) \(longitude)"
            }
            cell.typeLabel.text = airportInfos[K.type]
            cell.altitudeLabel.text = airportInfos[K.elevation]
            cell.timeZoneLabel.text = airportInfos[K.timeZone]
            cell.distanceLabel.text = airportInfos[K.radius]
            if let city = airportInfos[K.city], let country = airportInfos[K.country]{
                cell.cityCountryLabel.text = " \(country)     \(city)"
            }
            cell.operationalConditionLabel.text = airportInfos[K.status]
            if cell.operationalConditionLabel.text == "Operational"{
                cell.operastionalConditionImage.image = UIImage(systemName: "checkmark.circle")
                cell.operastionalConditionImage.tintColor = .green
                
            }else{
                cell.operastionalConditionImage.image = UIImage(systemName:"questionmark.circle" )
                cell.operastionalConditionImage.tintColor = .red
                
            }
            
            let rotate = nearestAirportModel[indexPath.row].bearing
            cell.arrowImage.transform = addImageView(angle: rotate).transform
            return cell
        }
        return UITableViewCell()
    }
    
    func addImageView(angle: Int)->UIImageView{
        let frame = CGRect(x: 33, y: 71, width: 46, height: 72)
        let newArrow = UIImageView(frame: frame)
        newArrow.image = UIImage(systemName: "arrow.up")
        let rotationAngle : CGFloat = CGFloat(angle) * CGFloat.pi / 180.0
        newArrow.transform = newArrow.transform.rotated(by: rotationAngle)
        return newArrow
    }
}


//MARK: - Location Delegate

extension  NearestViewController: CLLocationManagerDelegate{
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
    func updatenearest(sunTimesModel: SunTimesModel) {
    }
}
