//
// NearBy.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import CoreLocation

//MARK:RESPONSIBLE FOR CONFIGURING NEARBY SCENE
class NearBy: UIViewController {
    
    //    MARK:- OUTLETS -
    
    @IBOutlet weak var venueTableView: UITableView!
    @IBOutlet weak var modeSegmentController: UISegmentedControl!
    
    
    //    MARK:- VARIABLES -
    
    enum AppMode:String {
        case realtime = "realTime"
        case singleUpdate = "singleUpdate"
    }
    var items = [GroupItem]()

    var currentMode=""
    
    //   MARK:- LIFECYCLE -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNearByScene(currentMode)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- ACTIONS
    
    @IBAction func appModeChanged(_ sender: UISegmentedControl) {
        if  modeSegmentController.selectedSegmentIndex == 0 {
            currentMode = AppMode.realtime.rawValue
        } else {
            currentMode = AppMode.singleUpdate.rawValue
        }
        UserDefaults.standard.set(currentMode, forKey: "currentMode")
    }
    
    
    //    MARK:- FUNCTIONS -
    func setupNearByScene (_ navigationMode:String) {
        setupModeSegmentedController()
        
        switch navigationMode {
        case AppMode.realtime.rawValue:
            
            //TODO:
            // get current location
            // save current location
            // setuptableview
            let lat:Double = 30.121373
            let long:Double = 31.242247
            setupNearbyTableView(latitude: lat, longtude: long)
        case AppMode.singleUpdate.rawValue:
            //TODO: get current location
        
            let lat:Double = 30.121373
            let long:Double = 31.242247
            setupNearbyTableView(latitude: lat, longtude: long)
            
        default:
            break
        }
    }
    func setupModeSegmentedController() {
        modeSegmentController.setTitle("realtime", forSegmentAt: 0)
        modeSegmentController.setTitle("single update", forSegmentAt: 1)
        if currentMode == AppMode.realtime.rawValue {
                  modeSegmentController.selectedSegmentIndex = 0
        } else {
            modeSegmentController.selectedSegmentIndex = 1
        }
    }
    
    
    func setupNearbyTableView (latitude:Double , longtude:Double) {
        venueTableView.delegate = self
        venueTableView.dataSource = self
        venueTableView.register(UINib.init(nibName: "VenueTableViewCell", bundle: nil), forCellReuseIdentifier: "VenueTableViewCell")
        FoursquareServices.getGroupItems(latitude: latitude , longtude: longtude ,  completion:handelGetVenuesResponse(result:))
    }
    
    func handelGetVenuesResponse( result:Result<ExploreModel?,Error> ) {
        switch result {
        case .failure(_):
//            if latitude == 0 || long == 0 {
//                showAlert(title: "failed to get location", message: "Your location is unknown.Try other location.")  }
//            else {
                showAlert(title: "failed to connect", message: "Check your internet connection.This data have been cashed from your last session.")
//            }
        // TODO:fetch from coredata
        case .success(let responseData):
            guard  let cleanResponseData = responseData?.response.groups[0].items  else {return}
            self.items.append( contentsOf: cleanResponseData)
            venueTableView.reloadData()
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//    MARK:- EXTENSIONS -
extension NearBy:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as? VenueTableViewCell else { return VenueTableViewCell() }
        cell.configureVenueTableViewCell(venue: items[indexPath.row].venue)
        return cell
    }
    
    
}
