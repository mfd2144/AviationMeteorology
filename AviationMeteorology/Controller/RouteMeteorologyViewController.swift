//
//  ViewController.swift
//  AviationMeteorology
//
//  Created by Mehmet fatih DOĞAN on 9.02.2021.
//

import UIKit

class RouteMeteorologyViewController: UIViewController {
    
    
    weak var shapeLayer: CAShapeLayer?
    var orderNumber = 1
    
    
    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var metarModel : [WeathearMetarModel]?
    var tafModel : [WeatherTafModel]?
    var aviationAppData = AviationAppData()
    var routeModel: [RouteModel]?
    var tafLogic: Bool = false
    var metarLogic: Bool = false
    var selectedSection: Int?
    var airportsSet = Set<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aviationAppData.delegate = self
        tableView.rowHeight = 70
        
    
    }
    
    
    func createNewTafMetarUnionModel(){
        if metarLogic && tafLogic{
            routeModel = nil
            guard let metarArray = metarModel, let tafArray = tafModel else {return}
            for tafItem in tafArray{
                //   first we start wandering in the tafs
                var checklogic = false
                for metarItem in metarArray{
                    //   then for every piece of taf we looking same metar data and create new route model
                    
                    if tafItem.icao == metarItem.icao{
                        let newRouteModel = RouteModel(icao: metarItem.icao, metar: metarItem.text, taf: tafItem.text, metarModel:metarItem )
                        checklogic = true
                        
                        //         this part let us append new information in route model otheerwise(use append directly) its value doesn't change(nil)
                        if routeModel != nil{
                            routeModel!.append(newRouteModel)
                        }else{
                            routeModel = [newRouteModel]
                        }
                        
                    }
                }
                //                some airport doesn't have metar information, if we don't find any metar this part just add taf in pour model
                if !checklogic{
                    let newRouteModel = RouteModel(icao: tafItem.icao, metar:nil, taf: tafItem.text, metarModel:nil )
                    if routeModel != nil{
                        routeModel!.append(newRouteModel)
                    }else{
                        routeModel = [newRouteModel]
                    }
                }
            }
            
            metarLogic = false
            tafLogic = false
            tableView.reloadData()
        }
        
        
    }
    
    
}


extension RouteMeteorologyViewController: AviationAppDelegate{
    func updateMetar(weatherMetarArray: [WeathearMetarModel], logic: Bool) {
        metarModel = weatherMetarArray
        metarLogic = logic
        createNewTafMetarUnionModel()
    }
    
    func updateTaf(weatherTafArray: [WeatherTafModel], logic: Bool) {
        tafModel = weatherTafArray
        tafLogic = logic
        createNewTafMetarUnionModel()
    }
    
    //    be empty
    func updatenearest(nearestAirportArray: [NearestAirportModel]) {
    }
    func updatenearest(sunTimesModel: SunTimesModel) {
    }
}



extension RouteMeteorologyViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return routeModel?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let route = routeModel?[section]{
            return route.metar != nil ? 2 : 1
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let route = routeModel?[section]{
            return route.icao
        }
        else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.routecellIdentification, for: indexPath) as! RouteTableViewCell
        if indexPath.row == 0{
            cell.resultLabel.text = routeModel![indexPath.section].taf
            
        }else{
            cell.resultLabel.text = routeModel![indexPath.section].metar
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if ((routeModel?[indexPath.section].metarModel) != nil) && indexPath.row == 1{
            selectedSection = indexPath.section
            performSegue(withIdentifier: K.routeToDetailIdentification, sender: self)
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! DecodedMetarViewController
        if let model = routeModel?[selectedSection!].metarModel  {
            destinationVC.weatherModel = model
        }
        
    }
    
}
extension RouteMeteorologyViewController{
    
    
    func drawLine(order: Int,icao: String) {
        // remove old shape layer if any
        
        //        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath()
        let xPoint = routeView.frame.size.width
        let yPoint = routeView.frame.size.height
        
        
        
        switch order {
        case 1:
            addLabel(name: "LTAT",xPoint: xPoint/6-50, yPoint: yPoint/3*2,angle: 0)
        case 2:
            path.move(to: CGPoint(x: xPoint/6, y: yPoint/3*2))
            path.addLine(to: CGPoint(x: xPoint/6*2, y: yPoint/3))
            addLabel(name: icao,xPoint: xPoint/6*2-50, yPoint: yPoint/3-20,angle: 315)
        case 3:
            path.move(to: CGPoint(x: xPoint/6*2, y: yPoint/3))
            path.addLine(to: CGPoint(x: xPoint/6*3, y: yPoint/3 ))
            addLabel(name: icao,xPoint: xPoint/6*3-25, yPoint: yPoint/3,angle: 315)
        case 4:
            path.move(to: CGPoint(x: xPoint/6*3, y: yPoint/3 ))
            path.addLine(to: CGPoint(x: xPoint/6*4, y: yPoint/3 ))
            addLabel(name: icao,xPoint: xPoint/6*4, yPoint: yPoint/3-20,angle: 315)
        case 5:
            path.move(to: CGPoint(x: xPoint/6*4, y: yPoint/3 ))
            path.addLine(to: CGPoint(x: xPoint/6*5, y: yPoint/3*2))
            addLabel(name: icao,xPoint: xPoint/6*5, yPoint: yPoint/3*2,angle: 0)
        default:
            return
            
        }
        
        //         create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        
        // animate it
        
        routeView.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        self.shapeLayer = shapeLayer
    }
    func addLabel(name: String,xPoint: CGFloat, yPoint: CGFloat,angle: CGFloat){
        
        let textLabel = UILabel(frame: CGRect(x:  xPoint, y: yPoint, width: 50, height: 20))
        textLabel.text = name
        textLabel.tag = 101
        if angle != 0{
            let newAngle = CGFloat(.pi/angle/180)
            textLabel.transform = textLabel.transform.rotated(by: newAngle)}
        textLabel.font = UIFont(name: "System", size: CGFloat(7))
        routeView.addSubview(textLabel)
    }
}
extension RouteMeteorologyViewController: UISearchBarDelegate{
    

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length >  0{
            let char = text.cString(using: String.Encoding.utf8)!
            strcmp(char, "\\b") == -92 ? print("delete") : nil
            clearTextField()
        }
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
//        uppercase users input
        searchBar.text = searchBar.text?.uppercased()
        if (searchBar.text?.count == 4 || searchBar.text?.count == 9 || searchBar.text?.count == 14 || searchBar.text?.count == 19) {
//            add dash between airports
            searchBar.text?.append("-")

            let icaoCodes = searchBar.text?.split(separator: "-").last
            drawLine(order: orderNumber, icao: String(icaoCodes!))
            orderNumber += 1
            //        our control variable for searchbar
        }
        if searchBar.text?.count == 24{
            //            it start when user enters 5 icao codes
            searchBar.endEditing(true)
            searchBar.isUserInteractionEnabled = false
            let icaoCodes = searchBar.text?.split(separator: "-").last
            drawLine(order: orderNumber, icao: String(icaoCodes!))
            searchBarSearchButtonClicked(searchBar)

        }
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var icaoCodes = Array<String>()
        icaoCodes.append(contentsOf: (searchBar.text?.split(separator: "-").map({String($0)}))!)
        searchBar.endEditing(true)
        aviationAppData.weatherRequest(codesICAO: icaoCodes, reportType: K.metar)
        aviationAppData.weatherRequest(codesICAO: icaoCodes, reportType: K.taf)

    }
    func clearTextField(){
        while routeView.viewWithTag(101) != nil{
            let textfield = routeView.viewWithTag(101)
            textfield!.removeFromSuperview()
        }
        shapeLayer?.path = nil
        self.shapeLayer?.removeFromSuperlayer()
        
        
        
        searchBar.text = nil
        orderNumber = 1
    }
}

