//
//  SunTimesViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 9.02.2021.
//

import UIKit

class SunTimesViewController: UIViewController {

    var aviationAppData = AviationAppData()
    var sunTimesModel: SunTimesModel?
    var choseTimeZone = "local"
    
    @IBOutlet weak var icaoTextField: UITextField!
    @IBOutlet weak var civilDawnLabel: UILabel!
    @IBOutlet weak var civilDuskLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aviationAppData.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton){
        if icaoTextField.text?.count == 4 {
            aviationAppData.sunTimesAirport(icao: (icaoTextField?.text)!)
            icaoTextField.endEditing(true)
            icaoTextField.text = ""
        }
        
    }

    @IBAction func timeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
           choseTimeZone = "local"
            localFiller()
        }else{
            choseTimeZone = "UTC"
            utcFiller()
        }
    }
    func localFiller(){
        if let dusk = sunTimesModel?.civil_dusk_local, let dawn = sunTimesModel?.civil_dawn_local, let sunSet = sunTimesModel?.sun_set_local, let sunRise = sunTimesModel?.sun_rise_local{
            civilDuskLabel.text = dusk
            civilDawnLabel.text = dawn
            sunSetLabel.text = sunSet
            sunRiseLabel.text = sunRise
            
        }
    }
    func utcFiller(){
        if let dusk = sunTimesModel?.civil_dusk_utc, let dawn = sunTimesModel?.civil_dawn_utc, let sunSet = sunTimesModel?.sun_set_utc, let sunRise = sunTimesModel?.sun_rise_utc{
            civilDuskLabel.text = dusk
            civilDawnLabel.text = dawn
            sunSetLabel.text = sunSet
            sunRiseLabel.text = sunRise
        }
        
    }
    
}
extension SunTimesViewController: AviationAppDelegate{
    func updateMetar(weatherMetarArray: [WeathearMetarModel], logic: Bool) {
        
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel], logic: Bool) {
        
    }
    
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
        
    }
    
    func updatenearest(sunTimesModel: SunTimesModel) {
        print("1")
        self.sunTimesModel = sunTimesModel
        print(sunTimesModel.data)
        choseTimeZone == "local" ? localFiller() : utcFiller()

        
    }
    
    
}
