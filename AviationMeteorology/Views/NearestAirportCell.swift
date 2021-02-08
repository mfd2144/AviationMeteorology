//
//  NearestAirportCell.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 7.02.2021.
//

import UIKit

class NearestAirportCell: UITableViewCell {

    @IBOutlet weak var operationalConditionLabel: UILabel!
    @IBOutlet weak var operastionalConditionImage: UIImageView!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var bearingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinateLbel: UILabel!
    @IBOutlet weak var icaoLabel: UILabel!
    @IBOutlet weak var iataLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
