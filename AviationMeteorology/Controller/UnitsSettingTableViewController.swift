//
//  UnitsSettingTableViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 3.02.2021.
//

import UIKit


class UnitsSettingTableViewController: UITableViewController {
    var startingSettings :Dictionary<String,String> = [:]
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        loadScreen()
    }
    //MARK: - A Button Pressed
//    When click a box,one of the following actions will start
    @IBAction func elevationPressed(_ sender: UIButton){
        startingSettings[K.elevation] = sender.currentTitle == "1" ? Settings.feet.rawValue : Settings.meters.rawValue
        saveSettings()
        
    }
    
    @IBAction func visibilityPressed(_ sender: UIButton) {
        startingSettings[K.visibility] = sender.currentTitle == "1" ? Settings.meters.rawValue : Settings.miles.rawValue
        saveSettings()
        
    }
    @IBAction func temperatureAndDewPressed(_ sender: UIButton){
        startingSettings[K.temperature] = sender.currentTitle == "1" ? Settings.celsius.rawValue : Settings.fahrenheit.rawValue
        startingSettings[K.dewpoint] = sender.currentTitle == "1" ?  Settings.celsius.rawValue : Settings.fahrenheit.rawValue
        saveSettings()
        
    }
    @IBAction func barometerPressed(_ sender: UIButton){
        switch sender.currentTitle {
        case "1" : startingSettings[K.barometer] = Settings.hg.rawValue
        case "2" : startingSettings[K.barometer] = Settings.kpa.rawValue
        case "3" : startingSettings[K.barometer] = Settings.mb.rawValue
        default:
            startingSettings[K.barometer] = Settings.hpa.rawValue
        }
        saveSettings()
    }
    @IBAction func windPressed(_ sender: UIButton){
        switch sender.currentTitle {
        case "1" : startingSettings[K.wind] = Settings.speed_kts.rawValue
        case "2" : startingSettings[K.wind] = Settings.speed_kph.rawValue
        case "3" : startingSettings[K.wind] = Settings.speed_mph.rawValue
        default:
            startingSettings[K.wind] = Settings.speed_mps.rawValue
        }
        saveSettings()
    }
    @IBAction func defaultButtonPressed(_ sender: UIBarButtonItem) {
        loadDefaults()
    }
}




//MARK: - Settings and Screen Manupilation
extension UnitsSettingTableViewController{
//   Uusing Setting.plist to load starting settings
    func loadSettings(){
        guard let url = Bundle.main.url(forResource: "Settings", withExtension: "plist") else {
            return
        }
        guard let settings = NSDictionary(contentsOf: url) as? Dictionary<String,String> else {return}
        startingSettings = settings
        
    }
//    Save settings changes in plist
    func saveSettings(){
        guard let url = Bundle.main.url(forResource: "Settings", withExtension: "plist") else {
            return
        }
        let newSettings = startingSettings as NSDictionary
        do {
            try newSettings.write(to: url)
        } catch  {
            fatalError()
        }
        
        loadScreen()
    }
//    load screen according to startingSettings
    func loadScreen(){
        for (key,value) in startingSettings{
            switch key{
            case K.barometer: loadScreenModel(buttons: [hgButton,hpaButton,kpaButton,mbButton],rawValue:value)
            case K.wind: loadScreenModel(buttons: [mphButton,mpsButton,knotButton,kphButton],rawValue:value)
            case K.dewpoint: loadScreenModel(buttons: [celsiusButton,fahreinheitButton],rawValue:value)
            case K.elevation:loadScreenModel(buttons: [feetButton,metersButton],rawValue:value)
            case K.temperature: loadScreenModel(buttons: [celsiusButton,fahreinheitButton],rawValue:value)
            case K.visibility: loadScreenModel(buttons: [visibiltyMiles,visibilityMeters],rawValue:value)
            default:
                continue
            }
        }
    }
//    Take UI Button array and decide which box will be fill according to rawValue of Settings
        func loadScreenModel(buttons: [UIButton],rawValue: String){
            guard let chosenSettings = Settings.init(rawValue: rawValue) else {return}
            let index: Int = chosenSettings.index
            let fill = UIImage(systemName: "square.fill")
            let empty = UIImage(systemName: "square")
            buttons[index].setImage(fill, for: .normal)
            var newButtons = buttons
            newButtons.remove(at: index)
            for item in 0...newButtons.count-1{
            newButtons[item].setImage(empty, for: .normal)
            
        }
    }
//    default settings
    func loadDefaults(){
        let defaultSettings = [
            K.elevation: Settings.feet.rawValue,
            K.temperature: Settings.celsius.rawValue,
            K.wind: Settings.speed_kts.rawValue,
            K.dewpoint: Settings.celsius.rawValue,
            K.barometer: Settings.hg.rawValue, 
            K.visibility: Settings.meters.rawValue
        ]
        startingSettings = defaultSettings
        saveSettings()
    }
    
    
}

enum Settings:String{
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
    case speed_mph = "speed_mph"
    case speed_mps = "speed_mps"
    case speed_kts = "speed_kts"
    case speed_kph = "speed_kph"
    case feet = "feet"
    case meters = "meters"
    case miles = "miles"
    case hpa = "hpa"
    case kpa = "kpa"
    case hg = "hg"
    case mb = "mb"
    
}

extension Settings{
    var index: (Int){
        switch self {
        case .hg: return 0
        case .hpa: return 1
        case .kpa: return 2
        case .mb: return 3
        case .feet: return 0
        case .meters: return 1
        case .miles: return 0
        case .celsius: return 0
        case .fahrenheit: return 1
        case .speed_mph: return 0
        case .speed_mps: return 1
        case .speed_kts: return 2
        case .speed_kph: return 3
        }
    }
}

