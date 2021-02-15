//
//  UnitsSettingTableViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 3.02.2021.
//

import UIKit


class UnitsSettingTableViewController: UITableViewController {
    
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
    var actualSettings: SettingsModel?
    
    @IBOutlet weak var hpaButton: UIButton!
    @IBOutlet weak var mpsButton: UIButton!
    @IBOutlet weak var kphButton: UIButton!
    @IBOutlet weak var mphButton: UIButton!
    @IBOutlet weak var knotButton: UIButton!
    @IBOutlet weak var mbButton: UIButton!
    @IBOutlet weak var kpaButton: UIButton!
    @IBOutlet weak var hgButton: UIButton!
    @IBOutlet weak var celsiusButton: UIButton!
    @IBOutlet weak var fahreinheitButton: UIButton!
    @IBOutlet weak var visibilityMeters: UIButton!
    @IBOutlet weak var visibiltyMiles: UIButton!
    @IBOutlet weak var feetButton: UIButton!
    @IBOutlet weak var metersButton: UIButton!
    @IBOutlet weak var distanceKmButton: UIButton!
    @IBOutlet weak var coordinateDegreeButton: UIButton!
    @IBOutlet weak var coordinateDecimalButton: UIButton!
    @IBOutlet weak var distanceMilesButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actualSettings = StartingSettings.startingSettingsModel
        loadScreen()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - A Button Pressed
    //    When click a box,one of the following actions will start
    @IBAction func elevationPressed(_ sender: UIButton){
        actualSettings?.elevation = sender.currentTitle == "1" ? Settings.feet.rawValue : Settings.meters.rawValue
        saveSettings()
        
    }
    
    @IBAction func visibilityPressed(_ sender: UIButton) {
        
        actualSettings?.visibility = sender.currentTitle == "1" ? Settings.meters.rawValue : Settings.miles.rawValue
        saveSettings()
        
    }
    @IBAction func temperatureAndDewPressed(_ sender: UIButton){
        actualSettings?.temperature = sender.currentTitle == "1" ? Settings.celsius.rawValue : Settings.fahrenheit.rawValue
        actualSettings?.dewpoint = sender.currentTitle == "1" ?  Settings.celsius.rawValue : Settings.fahrenheit.rawValue
        
        saveSettings()
        
    }
    @IBAction func barometerPressed(_ sender: UIButton){
        switch sender.currentTitle {
        case "1" : actualSettings?.barometer = Settings.hg.rawValue
        case "2" : actualSettings?.barometer = Settings.kpa.rawValue
        case "3" : actualSettings?.barometer = Settings.mb.rawValue
        default:
            actualSettings?.barometer = Settings.hpa.rawValue
        }
    
        saveSettings()
    }
    @IBAction func windPressed(_ sender: UIButton){
        
        switch sender.currentTitle {
        case "1" : actualSettings?.wind = Settings.speed_kts.rawValue
        case "2" : actualSettings?.wind = Settings.speed_kph.rawValue
        case "3" : actualSettings?.wind = Settings.speed_mph.rawValue
        default:
            actualSettings?.wind = Settings.speed_mps.rawValue
        }
    
        saveSettings()
    }
    @IBAction func distanceButtonPressed(_ sender: UIButton){
        actualSettings?.distance = sender.currentTitle == "1" ? Settings.meters.rawValue : Settings.miles.rawValue
        saveSettings()
        
    }
    @IBAction func coordinateButtonPressed(_ sender: UIButton){
        actualSettings?.coordinates = sender.currentTitle == "1" ? Settings.degrees.rawValue : Settings.decimal.rawValue
        saveSettings()
    }
    @IBAction func defaultButtonPressed(_ sender: UIBarButtonItem) {
       loadDefaults()
        
    }
}




//MARK: - Settings and Screen Manupilation

extension UnitsSettingTableViewController{

    
    func loadSettings(){
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: path!)
           actualSettings = try decoder.decode(SettingsModel.self, from: data)
            loadScreen()
        }catch{
                print(error.localizedDescription)
            }
            
        }
        
    
    func saveSettings(){
        let encoder = PropertyListEncoder()
        do {
            let _data = try encoder.encode(actualSettings)
            try _data.write(to: path!)
            loadScreen()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    

    func loadScreen(){
        guard let actualSettings = actualSettings else { return }
        loadScreenModel(buttons: [hgButton,hpaButton,kpaButton,mbButton],rawValue:actualSettings.barometer)
        loadScreenModel(buttons: [mphButton,mpsButton,knotButton,kphButton],rawValue:actualSettings.wind)
        loadScreenModel(buttons: [celsiusButton,fahreinheitButton],rawValue:actualSettings.dewpoint)
        loadScreenModel(buttons: [celsiusButton,fahreinheitButton],rawValue:actualSettings.temperature)
        loadScreenModel(buttons: [feetButton,metersButton],rawValue:actualSettings.elevation)
        loadScreenModel(buttons: [visibiltyMiles,visibilityMeters],rawValue:actualSettings.visibility)
        loadScreenModel(buttons: [distanceMilesButton,distanceKmButton],rawValue:actualSettings.distance)
        loadScreenModel(buttons: [coordinateDegreeButton,coordinateDecimalButton],rawValue:actualSettings.coordinates)
    }
   
    //    Take UI Button array and decide which box will be fill according to rawValue of Settings
    func loadScreenModel(buttons: [UIButton],rawValue: String){
        guard let chosenSettings = Settings.init(rawValue: rawValue) else {return}
        let index: Int = chosenSettings.info.index
        let fill = UIImage(systemName: "square.fill")
        let empty = UIImage(systemName: "square")
        buttons[index].setImage(fill, for: .normal)
        var newButtons = buttons
        newButtons.remove(at: index)
        for item in 0...newButtons.count-1{
            newButtons[item].setImage(empty, for: .normal)
            
        }
    }
//        default settings
        func loadDefaults(){
            let defaultSettings = SettingsModel(elevation: Settings.feet.rawValue, temperature: Settings.celsius.rawValue, wind:  Settings.speed_kts.rawValue, dewpoint: Settings.celsius.rawValue, barometer: Settings.hg.rawValue, visibility: Settings.meters.rawValue, coordinates: Settings.degrees.rawValue, distance: Settings.meters.rawValue)

            actualSettings = defaultSettings
            saveSettings()
        }
    
    
}




