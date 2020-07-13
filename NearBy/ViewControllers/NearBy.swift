//
// NearBy.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

//MARK:RESPONSIBLE FOR CONFIGURING NEARBY SCENE
class NearBy: UIViewController,CoreLocationServiceDelegate {
    
    //    MARK:- OUTLETS -
    @IBOutlet weak var errorMessageLable: UILabel!
    @IBOutlet weak var errorDetailsLable: UILabel!
    @IBOutlet weak var venueTableView: UITableView!
    @IBOutlet weak var modeSegmentController: UISegmentedControl!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var userWarningImage: UIImageView!
    @IBOutlet weak var errorMessageTimer: UILabel!
    
    
    
    
    
    //    MARK:- VARIABLES -
    private var apiVenues  = [GroupItem]() // contains arounded Venues
    private var coreDataItems = [VenueModel]()
    var errorTimerLimit = 5  //controle error message counter limit.
    var errorTimerCountSpeed:Double = 6 //controle error message counter speed.
    var isConnectedToInternet:Bool?
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
    let spinner = SpinnerView(frame: CGRect(x:(UIScreen.main.bounds.width-20)/2, y:(UIScreen.main.bounds.height)/2, width: 100, height: 100))
    
    
    
    
    
    
    //   MARK:- LIFECYCLE -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNearByScene(currentMode: currentAppMode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    
    //MARK:- ACTIONS -
    //Controle App mode (realTime / singleTime)
    @IBAction func appModeChanged(_ sender: UISegmentedControl) {
        if  modeSegmentController.selectedSegmentIndex == 0 {
            currentMode = StaticValues.shared.realtime
        } else {
            currentMode = StaticValues.shared.singleUpdate
        }
        UserDefaults.standard.set(currentMode, forKey: StaticValues.shared.currentMode )
        CoreLocationService.getLocation(appMode: currentAppMode, completion: handleGetLocation(locationData:))
    }
    
    
    //    MARK:- FUNCTIONS -
   
    //MARK:- Handle location change
    
    func subscribeInLocationUpdate () {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationChangeNotification(_:)), name: Notification.Name("handleLocationUpdate"), object: nil)
    }
    
    @objc func handleLocationChangeNotification(_ notification:NSNotification) {
        CoreLocationService.getLocation(appMode: currentAppMode, completion: handleGetLocation(locationData:))
    }
    func handleGetLocation (locationData:LocationData) {
        guard locationData.latitude != 0 && locationData.longitude != 0 else {
            setupInErrorMode(in: .unknownLocation)
            return
        } 
        let lat = locationData.latitude!
        let long = locationData.longitude!
        FoursquareServices.getGroupItems(latitude: lat, longtude: long,  completion:handleGetGroupItems(result:))
    }
    
     //MARK:- Get Venues based on location and appMode.
    
    func handleGetGroupItems( result:Result<ExploreModel?,ErrorHandler> ) {
        switch result {
            
        case .success(let responseData):
            guard let cleanResponseData = responseData?.response.groups[0].items
            else  {
                    setupInErrorMode(in:.somethingWentWrong)
                    return
            }
            guard cleanResponseData.count>0 else { setupInErrorMode(in: .noDataFound)
                    return
            }
            self.apiVenues = cleanResponseData
            self.venueTableView.reloadData()
            persistenceService.shared.deleteCashedItems(completion: handleCachedItems(result:))
            maskView.isHidden=true
            spinner.removeFromSuperview()
            
        case .failure(let error):
            if error.localizedDescription == ErrorHandler.offline.localizedDescription{
                isConnectedToInternet = false
                setupInErrorMode(in: .networkDisconnection)
            } else {
                isConnectedToInternet = true
                setupInErrorMode(in: .somethingWentWrong)
            }
        }
        //print(apiVenues)
    }
    //MARK: Handle caching
    func handleLoadCashedItems(result:Result<[VenueModel],Error>){
        switch result {
        case .success(let cachedVenues):
            guard cachedVenues.count > 0 else {
                setupInErrorMode(in: .cannotLoadCachedData)
                return
            }
            self.coreDataItems = cachedVenues
            self.venueTableView.reloadData()
            
        case .failure(_):
            setupInErrorMode(in: .cannotLoadCachedData)
        }
    }
    func handleCachedItems(result:Result<Bool, Error>) {
        switch result {
        case .success(let success):
            if success == true  {break}
        case .failure(_):
            setupInErrorMode(in: .cannotCashData)
        }
    }
   
    //MARK:- Subscribe to location error notification .
    func subscribeInLocationError() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationErrorNotification), name: Notification.Name("handleLocationError"), object: nil)
    }
    @objc  func handleLocationErrorNotification (_ notification:NSNotification) {
        setupInErrorMode(in: .unknownLocation)
    }
     
    //MARK:- Setup and configuration -
    //MARK:- Setup Scene -
    func setupNearByScene (currentMode:appMode ) {
        setupModeSegmentedController()
        configureNearbyTableView()
        CoreLocationService.getLocation(appMode: currentMode, completion: handleGetLocation(locationData:))
        subscribeInLocationUpdate()
        subscribeInLocationError()
        errorMessageLable.text=""
        errorDetailsLable.text = ""
        errorMessageTimer.text = ""
        errorMessageTimer.isHidden = false
        maskView.isHidden = false
        spinner.removeFromSuperview()
    }
    
    //MARK:- Segmented controle configuration
    
    func setupModeSegmentedController() {
        modeSegmentController.setTitle("realtime", forSegmentAt: 0)
        modeSegmentController.setTitle("single update", forSegmentAt: 1)
        if currentMode == StaticValues.shared.realtime {
            modeSegmentController.selectedSegmentIndex = 0
        } else {
            modeSegmentController.selectedSegmentIndex = 1
        }
    }
    
    //MARK:- nearByTable configuration
    
    func configureNearbyTableView() {
        venueTableView.delegate = self
        venueTableView.dataSource = self
        venueTableView.register(UINib.init(nibName:StaticValues.shared.nibName , bundle: nil), forCellReuseIdentifier: StaticValues.shared.venueTableViewCellId)
    }
    
    //MARK:- Alert configuration
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Timer configuration
    func increaseTimerLable(to endValue: Int) {
        let duration: Double = errorTimerCountSpeed //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.errorMessageTimer.text = "\(i)"
                    if i == 5 && self.isConnectedToInternet == false{
                        self.maskView.isHidden  = true
                    }
                }
            }
        }
    }
}



//    MARK:- TableView functions. -
extension NearBy:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConnectedToInternet == true {return  apiVenues.count }
        else { return  coreDataItems.count }
    }
    
    
    //Configure table view cells 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableViewCell", for: indexPath) as? VenueTableViewCell else { return VenueTableViewCell() }
        
        let placeHolder  = UIImage(named:StaticValues.shared.imagePlaceholder)
        cell.venuePhoto.image = nil
        DispatchQueue.main.async {
            if self.isConnectedToInternet == true {
                FoursquareServices.getVenuePhoto(venueId: (self.apiVenues[indexPath.row].venue?.id)!) { result in
                    var venueImage : UIImage?
                    let venue = self.apiVenues[indexPath.row].venue
                    
            switch result {
               case .success(let data) :
                        
                        if let data = data {
                            venueImage = UIImage(data: data)
                            cell.configureVenueTableViewCell(apiVenue: venue, venueImage: venueImage)
                            persistenceService.shared.saveData(item: venue!, venueImage: data, completion: self.handleCachedItems(result:))
                        } else {
                            cell.configureVenueTableViewCell(apiVenue: venue, venueImage: placeHolder )
                        }
                        
               case .failure(_):
                        
                        cell.configureVenueTableViewCell(apiVenue: venue, venueImage: placeHolder )
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    cell.configureCoreVenueTableViewCell(coreDataVenue: self.coreDataItems[indexPath.row] )
                }
            }
        }
        
        return cell
    }
    
    
    //Table view cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    //return view.frame.height/6
    }
}




