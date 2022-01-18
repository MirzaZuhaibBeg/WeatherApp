//
//  LocationItemTableViewCell.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit

protocol LocationItemTableViewCellProtocol: AnyObject {
    
    func didSelectMarkFavoriteButton(locationInfo: LocationInfo?)
}

class LocationItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!

    weak var delegate: LocationItemTableViewCellProtocol?
    
    var locationInfo: LocationInfo?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Button Action Methods
    
    @IBAction func markFavoriteButtonAction(_ sender: Any) {
        self.delegate?.didSelectMarkFavoriteButton(locationInfo: self.locationInfo)
    }

    //MARK: Internal Methods
    
    func populateData(locationInfo: LocationInfo?) {
        guard let locationInfo = locationInfo, let title = locationInfo.title else {
            return
        }
        
        self.locationInfo = locationInfo
        
        self.labelTitle.text = title
    }
}
