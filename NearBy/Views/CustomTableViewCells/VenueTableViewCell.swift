//
//  VenueTableViewCell.swift
//  NearBy
//
//  Created by mahmoud diab on 7/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit
import CoreData

//MARK: RESPONSIBLE FOR CONFIGURING VENUE TABLE VIEW CELL.
class VenueTableViewCell: UITableViewCell {
    
    //MARK:- OUTLETS -
    @IBOutlet weak var venuePhoto: UIImageView!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueName: UILabel!
    
    //MARK:- VARIABLES -
    
    
    //MARK:- LIFECYCLE -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        venueName.text = ""
        venueAddress.text = ""
        venuePhoto.layer.cornerRadius = .pi*2
    }
    
    
    
    //MARK:- Functions-

    func configureVenueTableViewCell( apiVenue:Venue?,venueImage:UIImage? ) {
        self.venueName.text = apiVenue?.name
        let address  =  apiVenue?.location?.address
        self.venueAddress.text = address 
            venuePhoto.image = venueImage!
    }
    
    func configureCoreVenueTableViewCell( coreDataVenue:VenueModel ) {
        self.venueName.text = coreDataVenue.name
        self.venueAddress.text = coreDataVenue.address
        if let image = UIImage(data: coreDataVenue.venuePhoto!){
        self.venuePhoto.image = image
        
    }
    }
}


