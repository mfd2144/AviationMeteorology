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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var metarModel : [WeathearMetarModel]?
    var tafModel : [WeatherTafModel]?
    var aviationAppData = AviationAppData()
    var tafLogic = true
    var metarLogic = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadingIndicator.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = decodedButton.frame.size.height/2
        decodedButton.drawCorner( borderWidth: 2, cornerRadius: height)
        tafResultLabel.text = "-"
        metarResultLable.text = "-"
        aviationAppData.delegate = self
        decodedButton.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        
        navigationController?.navigationBar.isHidden = false
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
        if icaoCode.count != 4 {
            tafLogic = false
            metarLogic = false
            alertUser(nil,message: "You must enter 4 character in search field")
            searchBar.text = ""
            return
        }
        
//        Clear reports which belongs before search
        tafResultLabel.text = ""
        metarResultLable.text = ""
    
        decodedButton.isHidden = true
        
        aviationAppData.weatherRequest(codesICAO: [icaoCode], reportType: K.metar)
        aviationAppData.weatherRequest(codesICAO: [icaoCode], reportType: K.taf)
        
        searchBar.endEditing(true)
        searchBar.text = ""
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
}
//MARK: - WeatherDataDelegate
extension HomeViewController:AviationAppDelegate{
    func errorDidThrow(error: Error) {
        aviationAppData.userAlert(sender: self, message: error.localizedDescription)
    }
    

   

    func updateMetar(weatherMetarArray: [WeathearMetarModel]?, logic: Bool) {
        metarLogic = logic
        logic == false ? alertUser(metarResultLable) : nil
        if let weatherModel = weatherMetarArray{
        metarModel = weatherModel
        metarResultLable.text = metarModel![0].text
        decodedButton.isHidden = false
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel]?, logic: Bool) {
        tafLogic = logic
        logic == false ? alertUser(tafResultLabel) : nil
        if let weatherModel = weatherTafArray{
        tafModel = weatherModel
        tafResultLabel.text = tafModel![0].text
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
        
    }
    
    // These two functions is not used in this page
  
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
            }
    func updatenearest(sunTimesModel: SunTimesModel) {
    }
    
    func alertUser(_ textArea: UILabel?,message: String = "There isn't any reported TAF or METAR" ){
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        if !tafLogic, !metarLogic{
            tafLogic = true
            metarLogic = true
            aviationAppData.userAlert(sender: self, message: message)
        }
        guard let _textArea = textArea else { return }
        _textArea.text = "-"
    }
    
}



