//
//  AppErrorConditions.swift
//  NearBy
//
//  Created by mahmoud diab on 7/13/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
import UIKit

//    MARK:- Handle error conditions for a good user experience.
extension NearBy {
    enum errorMode {
        case networkDisconnection
        case unknownLocation
        case noDataFound
        case somethingWentWrong
        case cannotLoadCachedData
        case cannotCashData
        
    }
    func setupInErrorMode (in mode:errorMode) {
        switch mode {
        case .cannotCashData:
            handleCannotCachData()
        case.unknownLocation:
            handleUnknownLocation ()
            
        case .networkDisconnection:
            handleNetworkDisconnection ()
            
        case .somethingWentWrong :
            handleSomethingWentWrong()
            
        case .cannotLoadCachedData:
            handleFailToLoadCach()
            
        case .noDataFound:
            handleNoDataFound()
        }
    }
    
    func handleUnknownLocation (){
        if isConnectedToInternet == true {
            let userWarningImage  = StaticValues.shared.noVenuesAroundImage
            let  errorMessage = "Unknown location !!"
            let  errorDetails = " Make sure that your location service is enabled and try another location !!"
            self.handelError(warningImage: userWarningImage, errorMessage: errorMessage, errorDetails: errorDetails)
            DispatchQueue.main.async {
                self.maskView.isHidden = false
            }
            persistenceService.shared.loadCashedItems(completion: handleLoadCashedItems(result:))
        }
    }
    
    func handelError(warningImage:String,errorMessage:String,errorDetails:String)   {
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
            self.maskView.isHidden  = false
            self.userWarningImage.image = UIImage(named: warningImage)
            self.errorMessageLable.text = errorMessage.uppercased()
            self.errorDetailsLable.text = errorDetails.uppercased()
            self.spinner.removeFromSuperview()
        }
        
    }
    func handleNetworkDisconnection (){
        let errorMessage  = "Network disconnected,you are offline!!"
        let errorDetails  = "We will try to display venues from the last time you were online."
        
        handelError(warningImage: StaticValues.shared.networkDisconnectionImage, errorMessage: errorMessage, errorDetails: errorDetails)
        increaseTimerLable(to: errorTimerLimit)
      
        persistenceService.shared.loadCashedItems(completion: self.handleLoadCashedItems(result:))
  
    }
    func  handleSomethingWentWrong() {
        errorMessageTimer.isHidden = true
        let errorMessage = "Something is wrong!!"
        let errorDetails = "We are going to solve it."
        handelError(warningImage: StaticValues.shared.someThingWrongImage, errorMessage: errorMessage, errorDetails: errorDetails)
        increaseTimerLable(to: errorTimerLimit)
    }
    
    func handleNoDataFound (){
        self.errorMessageTimer.isHidden = true
        let errorMessage  = "No venues arround you!"
        let errorDetails  = "Try to change your location."
        self.handelError(warningImage: StaticValues.shared.noVenuesAroundImage, errorMessage: errorMessage, errorDetails: errorDetails) 
    }
    
    func handleCannotCachData(){
        //TODO:
    }
    func handleFailToLoadCach() {
        //TODO:
    }
    
}






