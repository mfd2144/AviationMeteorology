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
    
    @IBOutlet weak var icaoCodeLabel: UILabel!
    @IBOutlet weak var icaoTextField: UITextField!
    @IBOutlet weak var civilDawnLabel: UILabel!
    @IBOutlet weak var civilDuskLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var seachButton: UIButton!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seachButton.drawCorner(cornerRadius: seachButton.frame.size.height/2)
        aviationAppData.delegate = self
        icaoCodeLabel.text = ""
    }
    
    @IBAction func searchPressed(_ sender: UIButton){
        if icaoTextField.text?.count == 4 {
            aviationAppData.sunTimesAirport(icao: (icaoTextField?.text)!)
            icaoTextField.endEditing(true)
            icaoTextField.text = ""
        }else{
            aviationAppData.userAlert(sender: self, message: "ICAO code must have 4 characters")
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
        if let dusk = sunTimesModel?.civil_dusk_local, let dawn = sunTimesModel?.civil_dawn_local, let sunSet = sunTimesModel?.sun_set_local, let sunRise = sunTimesModel?.sun_rise_local, let icao = sunTimesModel?.icao{
            civilDuskLabel.text = dusk
            civilDawnLabel.text = dawn
            sunSetLabel.text = sunSet
            sunRiseLabel.text = sunRise
            icaoCodeLabel.text = icao
        }
    }
    func utcFiller(){
        if let dusk = sunTimesModel?.civil_dusk_utc, let dawn = sunTimesModel?.civil_dawn_utc, let sunSet = sunTimesModel?.sun_set_utc, let sunRise = sunTimesModel?.sun_rise_utc, let icao = sunTimesModel?.icao{
            civilDuskLabel.text = dusk
            civilDawnLabel.text = dawn
            sunSetLabel.text = sunSet
            sunRiseLabel.text = sunRise
            icaoCodeLabel.text = icao
        }
        
    }
    
}
extension SunTimesViewController: AviationAppDelegate{
    func errorDidThrow(error: Error) {
        aviationAppData.userAlert(sender: self, message: error.localizedDescription)
    }
    
    func updateMetar(weatherMetarArray: [WeathearMetarModel]?, logic: Bool) {
        
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel]?, logic: Bool) {
        
    }
    
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
        
    }
    
    func updatenearest(sunTimesModel: SunTimesModel) {
        self.sunTimesModel = sunTimesModel
        choseTimeZone == "local" ? localFiller() : utcFiller()

        
    }
    
    
}
