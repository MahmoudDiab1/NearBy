 

import Foundation
//
//  SceneDelegate.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import CoreLocation


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //MARK:- Handle launching in the last saved mode. ( realTime / singleTime )
        let nearByVC =  window?.rootViewController as! NearBy
        if let storedMode = UserDefaults.standard.string(forKey:StaticValues.shared.currentMode) {
            nearByVC.currentMode = storedMode
             } else {
            nearByVC.currentMode = StaticValues.shared.realtime
            UserDefaults.standard.set(StaticValues.shared.realtime,forKey:StaticValues.shared.currentMode)
        }
        guard let currentMode = UserDefaults.standard.string(forKey:StaticValues.shared.currentMode) else { return }
        var currentAppMode : appMode {
            var mode : appMode
            if currentMode == StaticValues.shared.realtime {
                mode = .realTimeUpdate
            } else {
                mode = .singleUpdateLocation
            }
            return mode
        }
        
        //MARK:- Check network existence.If no run app in Error mode (.networkDisconnection).
        NetworkEngine.isConnected{ isConnected in
            DispatchQueue.main.async {
                nearByVC.view.addSubview(nearByVC.spinner)
                
                if isConnected == true {
                    nearByVC.isConnectedToInternet = true
                    nearByVC.runGetLocation()
                    
                } else {
                    nearByVC.setupInErrorMode(in: .networkDisconnection)
                    nearByVC.isConnectedToInternet = false
                }
            }
        } 
    }
    
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

