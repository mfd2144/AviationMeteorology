//
//  HomeViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 31.01.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var decodedButton: UIButton!
    @IBOutlet weak var airportSearchPort: UISearchBar!
    @IBOutlet weak var metarResultLabel: UILabel!
    var metarModel : [WeathearMetarModel]?
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = decodedButton.frame.size.height/2
        decodedButton.drawCorner( borderWidth: 2, cornerRadius: height)
        metarResultLabel.text = ""
        weatherData.delegate = self
    }

    @IBAction func decodePressed(_ sender: UIButton) {
        metarResultLabel.text = metarModel![0].metarText
    }
    
}

//MARK: - SearchBarDelegate
extension HomeViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        weatherData.weatherSource(codesICAO: ["LTAT"])
        searchBar.endEditing(true)
    }
}
//MARK: - WeatherDataDelegate
extension HomeViewController:WeatherDataDelegate{
    func updateWeather(weatherArray: [WeathearMetarModel]) {
        metarResultLabel.text = weatherArray[0].metarText
    }
    

}
