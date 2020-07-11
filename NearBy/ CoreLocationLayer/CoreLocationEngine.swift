////
//// CoreLocationEngine.swift
////  NearBy
////
////  Created by mahmoud diab on 7/8/20.
////  Copyright © 2020 Diab. All rights reserved.
////
//
import Foundation
import CoreLocation

protocol CorLocationServiceDelegate {
    func showAlert(title:String,message:String)
}

class CoreLocationEngine: NSObject {
    public static var shared = CoreLocationEngine()
    
    //MARK:- VARIABLES
    var delegate : CorLocationServiceDelegate = NearBy()
    var locationManager = CLLocationManager()
    
    
    
    //MARK:- FUNCTIONS
    private func  configureLocationManager(appMode:AppModeEndPoint) {
        locationManager = appMode.locationManager
        locationManager.delegate = self
    }
    
    private func checkLocationAuthorization () {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways , .authorizedWhenInUse :
            break
        case .denied:
            delegate.showAlert(title: "Location Services denied", message: "Enable Location Services to access app functions.")
            return
        case .restricted:
            delegate.showAlert(title: "Location Services restricted", message: "Location Services restricted may be because parental control.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            delegate.showAlert(title: "Location service isn't determined yet", message: "Make sure that you enabled location service")
            return
        default:
            break
        }
    }
    
    func checkLocationServices(currentAppMode:AppModeEndPoint) {
        if CLLocationManager.locationServicesEnabled() {
            configureLocationManager(appMode: currentAppMode)
            checkLocationAuthorization()
        } else {
            delegate.showAlert(title: "Location services disabled", message: "Your location services is disabled.Try to go to settings and enable it")
        }
    }
    
}




//    MARK:- CLLOCATION MANAGER DELEGATE FUNCTIONS - 
extension CoreLocationEngine: CLLocationManagerDelegate {
    // save Double lat,long.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let updatedLocation = locations.last {
            let latitude = Double(updatedLocation.coordinate.latitude)
            let longitude = Double(updatedLocation.coordinate.longitude)
            print(updatedLocation)
            if latitude != UserDefaults.standard.double(forKey: StaticValues.shared.currentLatitude) {
                UserDefaults.standard.setValue(latitude, forKey: StaticValues.shared.currentLatitude)
                UserDefaults.standard.setValue(longitude, forKey: StaticValues.shared.currentLongitude)
                NotificationCenter.default.post(name: Notification.Name("handleLocationUpdate"), object: nil)
            }
        } else { delegate.showAlert(title: "Unknown location", message: "Faild to locate your location") }
        
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
        
        
    }
}
