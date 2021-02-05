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
            nameLabel.text = actualWeatherModel.name
            ceilingLabel.text = actualWeatherModel.ceiling[startingSettings[K.elevation]!]
            cloudLabel.text = actualWeatherModel.clouds
            flightRuleLabel.text = actualWeatherModel.flightCategory
            coordinatesLabel.text = " \(actualWeatherModel.location.first!), \(actualWeatherModel.location.last!)"
            timeLabel.text = actualWeatherModel.observedTime
            visibilityLabel.text = actualWeatherModel.visibility[startingSettings[K.visibility]!]
            conditionLabel.text = actualWeatherModel.condition["text"]
            dewPointLabel.text = actualWeatherModel.dewPoint[startingSettings[K.dewpoint]!]
            windLabel.text = actualWeatherModel.wind[startingSettings[K.wind]!]
            barometerLabel.text = actualWeatherModel.barometer[startingSettings[K.barometer]!]
            
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
        print(startingSettings)
    }
    
}
