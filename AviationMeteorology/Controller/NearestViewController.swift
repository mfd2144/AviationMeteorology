//
//  NearestViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 5.02.2021.
//

import UIKit
import CoreLocation

class NearestViewController: UIViewController, CLLocationManagerDelegate {
  
    var locationManager = CLLocationManager()
    var sliderValue = 10
    var aviationAppData = AviationAppData()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        sliderValue = Int(sender.value / 10) * 10
        distanceLabel.text = String(sliderValue)
        
        
        
    }
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBAction func searchButtonPressed(_ sender:UIButton){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            aviationAppData.nearestRequest(lat, lon, sliderValue)
            print("latitude")
            print(lat)
            print("longitude")
            print(lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

