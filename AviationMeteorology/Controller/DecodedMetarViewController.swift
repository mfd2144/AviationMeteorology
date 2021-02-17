//
//  DecodedMetarViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 3.02.2021.
//

import UIKit



class DecodedMetarViewController: UIViewController {
 
    var weatherModel : WeathearMetarModel?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var barometerLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var flightRuleLabel: UILabel!
    @IBOutlet weak var thermometerLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var ceilingLabel: UILabel!

    @IBOutlet weak var visibilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabelValues()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


    }
    
    func loadLabelValues(){
        if let actualWeatherModel = weatherModel{
            let screen = DecodedScreenLoadModel(weatherModel: actualWeatherModel).loadData()
            
            nameLabel.text = screen[K.airportName]
            ceilingLabel.text = screen[K.ceiling]
            cloudLabel.text = screen[K.cloud]
            flightRuleLabel.text = screen[K.flightRule]
            coordinatesLabel.text = screen[K.coordinates]
            timeLabel.text = screen[K.time]
            visibilityLabel.text = screen[K.visibility]
            conditionLabel.text = screen[K.condition]
            dewPointLabel.text = screen[K.dewpoint]
            windLabel.text = screen[K.wind]
            barometerLabel.text = screen[K.barometer]
            thermometerLabel.text = screen[K.temperature]
          
            
        }
    }
}











