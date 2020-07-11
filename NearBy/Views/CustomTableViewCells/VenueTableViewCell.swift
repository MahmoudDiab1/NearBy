//
//  VenueTableViewCell.swift
//  NearBy
//
//  Created by mahmoud diab on 7/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

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
        
    }
    
    
    
    //MARK:- ACTIONS -
    func configureVenueTableViewCell( venue:Venue? ) {
        self.venueName.text = venue?.name
        let address  = "\(String(describing:(venue?.location?.city))),\(String(describing: (venue?.location?.address)))."
        self.venueAddress.text = address
    }
    
}



//let suffix = (responseData?.response?.photos?.items[i]?.suffix)
