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
    
    @IBOutlet weak var tafMetarResultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = decodedButton.frame.size.height/2
        let buttonColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        decodedButton.drawCorner(CGColor: buttonColor, borderWidth: 2, cornerRadius: height)
        decodedButton.isHidden = true
        airportSearchPort.delegate = self

       
    }
   
    



}
extension HomeViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}
