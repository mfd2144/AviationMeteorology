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
        decodedButton.drawCorner( borderWidth: 2, cornerRadius: height)
        
    }
   
    



}
extension HomeViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}
