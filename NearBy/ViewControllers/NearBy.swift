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
class NearBy: UIViewController,CorLocationServiceDelegate {
    
    //    MARK:- OUTLETS -
    @IBOutlet weak var venueTableView: UITableView!
    @IBOutlet weak var modeSegmentController: UISegmentedControl!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var userWarningImage: UIImageView!
    
    //    MARK:- VARIABLES -
    var items = [GroupItem]() // contains arounded Venues
    var currentMode = ""
    var currentAppMode : appMode {
        var mode : appMode
        if currentMode == StaticValues.shared.realtime {
            mode = .realTimeUpdate
        } else {
            mode = .singleUpdateLocation
        }
        return mode
    }
    
    
    
    
    //   MARK:- LIFECYCLE -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNearByScene(currentMode: currentAppMode)
        subscribeInLocationUpdate()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- ACTIONS -
    
    @IBAction func appModeChanged(_ sender: UISegmentedControl) {
        if  modeSegmentController.selectedSegmentIndex == 0 {
            currentMode = StaticValues.shared.realtime
        } else {
            currentMode = StaticValues.shared.singleUpdate
        }
        
        UserDefaults.standard.set(currentMode, forKey: StaticValues.shared.currentMode )
        UserDefaults.standard.synchronize()
        CoreLocationService.getLocation(appMode: currentAppMode, completion: handelGetLocation(locationData:))
    }
    
    func handelGetLocation (locationData:LocationData) {
        guard let lat = locationData.latitude else {
            //            handle unknown location
            return
        }
        guard let    long = locationData.longitude else { return }
        
        FoursquareServices.getGroupItems(latitude: lat, longtude: long,  completion:handelGgetGroupItems(result:))
    }
    
    func handelGgetGroupItems( result:Result<ExploreModel?,ErrorHandler> ) {
        switch result {
        case .failure(let error):
            if error.localizedDescription == ErrorHandler.offline.localizedDescription{
                
                self.showAlert(title: "Failed to connect", message: "Check your internet connection.")
            }
            
            //handle 
        // TODO:save to core data coredata
        case .success(let responseData):
            guard  let cleanResponseData = responseData?.response.groups[0].items  else {return}
            
            items = cleanResponseData
            venueTableView.reloadData()
            print(items)
            print(items.count)
        }
    }
    
    //    MARK:- FUNCTIONS -
    
    //________________________________________! Setup Scene !___________________________________________//
    
    func setupNearByScene (currentMode:appMode ) {
        configureNearbyTableView()
        setupModeSegmentedController()
        CoreLocationService.getLocation(appMode:currentMode, completion: handelGetLocation(locationData:))
        
    }
    
    //_____________________________________! Segment Handeling !___________________________________________//
    
    func setupModeSegmentedController() {
        modeSegmentController.setTitle("realtime", forSegmentAt: 0)
        modeSegmentController.setTitle("single update", forSegmentAt: 1)
        if currentMode == StaticValues.shared.realtime {
            modeSegmentController.selectedSegmentIndex = 0
            
        } else {
            modeSegmentController.selectedSegmentIndex = 1
        }
    }
    
    
    //________________________________________! nearByTable Handeling _____________________________________!
    
    func configureNearbyTableView() {
        venueTableView.delegate = self
        venueTableView.dataSource = self
        venueTableView.register(UINib.init(nibName: "VenueTableViewCell", bundle: nil), forCellReuseIdentifier: "VenueTableViewCell")
    }
    
    
    //    Observ notification if location changed (Note: designed to be changed every 500 meter)
    func subscribeInLocationUpdate () {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserLocationChange(_:)), name: Notification.Name("handleLocationUpdate"), object: nil)
    }
    @objc func handleUserLocationChange(_ notification:NSNotification) {
        CoreLocationService.getLocation(appMode: currentAppMode, completion: handelGetLocation(locationData:))
    }
    
    func showAlert(title : String, message: String) {
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
        
        //
        //        FoursquareServices.getVenuePhotos(venue: items[indexPath.row].venue) { result in
        //            switch result {
        //            case .failure(_):
        //                // self.venuePhoto.image = arbitary image
        //                print("_____ > error photo")
        //            case .success(let responseData):
        //                if let photoItem = responseData?.response?.photos{
        //                    guard  let prefix = photoItem.items[0]?.prefix else {return}
        //                    guard let suffix = photoItem.items[0]?.suffix else {return}
        //                    let venuePhotoString =  prefix+"original"+suffix
        //                    let VenuePhotoUrl = URL(string:venuePhotoString)!
        //                    DispatchQueue.main.async {
        //                        do {
        //                            let venuePhotoData = try Data(contentsOf: VenuePhotoUrl)
        //                            cell.venuePhoto.image = UIImage(data: venuePhotoData )
        //                        } catch { fatalError(error.localizedDescription) }
        //                        print(VenuePhotoUrl)
        //                    }
        //                }
        //            }
        //        }
        return cell
    }
    
}


