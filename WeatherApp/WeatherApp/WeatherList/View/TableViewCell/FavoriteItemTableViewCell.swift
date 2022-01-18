//
//  FavoriteItemTableViewCell.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit

protocol FavoriteItemTableViewCellProtocol: AnyObject {
    
    func didSelectViewWeatherButton(favoriteInfo: FavoriteInfo?)
    
    func didSelectDeleteFavoriteButton(favoriteInfo: FavoriteInfo?)
}

class FavoriteItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var buttonViewWeather: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!

    weak var delegate: FavoriteItemTableViewCellProtocol?
    
    var favoriteInfo: FavoriteInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Helper Methods Methods

    private func initialSetup() {
        self.buttonViewWeather.layer.cornerRadius = 10.0
        self.buttonViewWeather.layer.borderColor = UIColor.black.cgColor
        self.buttonViewWeather.layer.borderWidth = 1.0
        
        self.buttonDelete.layer.cornerRadius = 10.0
        self.buttonDelete.layer.borderColor = UIColor.black.cgColor
        self.buttonDelete.layer.borderWidth = 1.0
    }
    
    //MARK: Button Action Methods
    
    @IBAction func viewWeatherButtonAction(_ sender: Any) {
        self.delegate?.didSelectViewWeatherButton(favoriteInfo: self.favoriteInfo)
    }

    @IBAction func deleteFavoriteButtonAction(_ sender: Any) {
        self.delegate?.didSelectDeleteFavoriteButton(favoriteInfo: self.favoriteInfo)
    }

    //MARK: Internal Methods
    
    func populateData(favoriteInfo: FavoriteInfo?) {
        guard let favoriteInfo = favoriteInfo, let title = favoriteInfo.title else {
            self.labelWeather.text = ""
            return
        }
        
        self.favoriteInfo = favoriteInfo

        self.labelTitle.text = title
        
        if let weatherReport = favoriteInfo.weatherReport {
            self.labelWeather.text = weatherReport
        } else {
            self.labelWeather.text = ""
        }
    }
}
