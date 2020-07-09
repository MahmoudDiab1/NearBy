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
        
        FoursquareServices.getVenuePhotos(venue: venue, completion: handelGetVenuePhoto(result:))
    }
    
    func handelGetVenuePhoto( result:Result<VenuePhotoModel?,Error> ) {
        switch result {
        case .failure(_):
            // self.venuePhoto.image = arbitary image
            print("error photo")
        case .success(let responseData):
            if let photoItem = responseData?.response?.photos{
                for i in 0..<photoItem.items.count {
                    guard  let prefix = photoItem.items[i]?.prefix else {continue}
                    guard let suffix = photoItem.items[i]?.suffix else {continue}
                    let venuePhotoString =  prefix+"original"+suffix
                    let VenuePhotoUrl = URL(string:venuePhotoString)!
                    
                    DispatchQueue.main.async {
                        do {
                            let venuePhotoData = try Data(contentsOf: VenuePhotoUrl)
                            self.venuePhoto.image = UIImage(data: venuePhotoData )
                        } catch { fatalError(error.localizedDescription) }
                        print(VenuePhotoUrl)
                    }
                }
                
            }
        }
    }
}

//let suffix = (responseData?.response?.photos?.items[i]?.suffix)
