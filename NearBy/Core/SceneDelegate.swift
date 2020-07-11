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
        
        // func initilizeAppMode
        guard let nearByVC = window?.rootViewController as? NearBy else { return }
        let storedMode = UserDefaults.standard.string(forKey:StaticValues.shared.currentMode)
        if storedMode == nil
        {
            nearByVC.currentMode = "realTime"
        }
        else
        {
            nearByVC.currentMode = UserDefaults.standard.string(forKey: StaticValues.shared.currentMode)!
        }
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

