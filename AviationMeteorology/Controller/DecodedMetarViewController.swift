//
//  DecodedMetarViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 3.02.2021.
//

import UIKit



class DecodedMetarViewController: UIViewController {
 
    var weatherModel : WeathearMetarModel?
    var startingSettings :Dictionary<String,String> = [:]
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        loadLabelValues()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false

    }
    
    func loadLabelValues(){
        if let actualWeatherModel = weatherModel{
            let screen = DecodedScreenLoadModel(weatherModel: actualWeatherModel, startingSettings: startingSettings).loadData()
            
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

extension DecodedMetarViewController {
    
    func loadSettings(){
        let url = Bundle.main.url(forResource: "Settings", withExtension: "plist")
        guard  let _url = url else {
            return
        }
        guard let settings = NSDictionary(contentsOf: _url) as? Dictionary<String,String> else {return}
        startingSettings = settings
    }
    
}









