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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
//            ceilingLabel.text = actualWeatherModel.ceiling
            cloudLabel.text = actualWeatherModel.clouds
            flightRuleLabel.text = actualWeatherModel.flightCategory
            coordinatesLabel.text = " \(actualWeatherModel.location.first!), \(actualWeatherModel.location.last!)"
            timeLabel.text = actualWeatherModel.observedTime
//            visibilityLabel.text = actualWeatherModel.visibilityMeters
            conditionLabel.text = actualWeatherModel.condition["text"]
             
        }
    }
}
