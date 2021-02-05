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
    @IBOutlet weak var tafResultLabel: UILabel!
    @IBOutlet weak var metarResultLable: UILabel!
    var metarModel : [WeathearMetarModel]?
    var tafModel : [WeatherTafModel]?
    var weatherData = WeatherData()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = decodedButton.frame.size.height/2
        decodedButton.drawCorner( borderWidth: 2, cornerRadius: height)
        tafResultLabel.text = "-"
        metarResultLable.text = "-"
        weatherData.delegate = self
        decodedButton.isHidden = true
        
    }
    
    @IBAction func decodePressed(_ sender: UIButton) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? DecodedMetarViewController{
            guard let singleMetarModel = metarModel?[0] else { return }
            destinationVC.weatherModel = singleMetarModel
            
        }
    }
    
}

//MARK: - SearchBarDelegate
extension HomeViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let icaoCode = searchBar.text!
        tafResultLabel.text = ""
        metarResultLable.text = ""
        decodedButton.isHidden = true
        self.weatherData.weatherSource(codesICAO: [icaoCode],reportType: K.metar)
        self.weatherData.weatherSource(codesICAO: [icaoCode],reportType: K.taf)
        searchBar.endEditing(true)
        searchBar.text = ""
    }
}
//MARK: - WeatherDataDelegate
extension HomeViewController:WeatherDataDelegate{
    func updateMetar(weatherMetarArray: [WeathearMetarModel]) {
        metarModel = weatherMetarArray
        metarResultLable.text = metarModel![0].metarText
        print(metarResultLable.text)
        decodedButton.isHidden = false
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel]) {
        tafModel = weatherTafArray
        tafResultLabel.text = tafModel![0].tafText
        print(tafResultLabel.text)
    }
}



