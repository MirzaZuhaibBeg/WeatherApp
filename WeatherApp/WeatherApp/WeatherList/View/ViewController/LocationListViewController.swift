//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit

enum LocationListViewType: Int {
    case LocationListViewType_LocationItem = 0
    case LocationListViewType_FavoriteItem
}

protocol LocationListViewProtocol: AnyObject {
    
    func populateLocationItemArray(locationInfoArray :[LocationInfo]?)
    
    func populateLocationSearchError()
    
    func populateFavoriteItemArray(favoriteInfoArray :[FavoriteInfo]?)
    
    func populateWeatherReport(favoriteInfo :FavoriteInfo?)
}

class LocationListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSearchLocation: UIButton!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var locationInfoArray :[LocationInfo]?
    var favoriteInfoArray :[FavoriteInfo]?

    var presenter: LocationListPresenterProtocol?
    
    //MARK: View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = LocationListPresenter()
        self.presenter?.attachView(self)
        self.customizeView()
        self.manageSearchButtonState()
        self.presenter?.fetchAllFavorite()
    }
    
    //MARK: Helper Methods
    
    private func customizeView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.btnSearchLocation.layer.cornerRadius = 10.0
        self.btnSearchLocation.layer.borderColor = UIColor.black.cgColor
        self.btnSearchLocation.layer.borderWidth = 1.0
        self.btnSearchLocation.setTitle("Search Location", for: .normal)
        
        self.textField.layer.cornerRadius = 10.0
        self.textField.layer.borderColor = UIColor.blue.cgColor
        self.textField.layer.borderWidth = 1.0
        
        self.textField.leftViewMode = .always
        self.textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        
        self.tableView.register(UINib(nibName: "LocationItemTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationItemTableViewCell")
        self.tableView.register(UINib(nibName: "FavoriteItemTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteItemTableViewCell")
    }

    private func manageSearchButtonState() {
        self.tableView.isHidden = true
        self.textField.isHidden = true
        self.btnSearchLocation.isHidden = false
    }

    private func showLoader() {
        self.view.isUserInteractionEnabled = false
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    private func hideLoader() {
        self.view.isUserInteractionEnabled = true
        self.activityIndicatorView.isHidden = true
        self.activityIndicatorView.stopAnimating()
    }

    //MARK: Button Action Methods
    
    @IBAction func searchLocationButtonAction(_ sender: Any) {
        self.tableView.isHidden = false
        self.textField.isHidden = false
        self.btnSearchLocation.isHidden = true
        self.textField.becomeFirstResponder()
    }
    
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        guard let text = textField.text else {
            return true
        }
        
        self.showLoader()
        self.presenter?.searchLocation(textInput: text)
        return true
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tblView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case LocationListViewType.LocationListViewType_LocationItem.rawValue:
            return self.locationInfoArray?.count ?? 0
            
        case LocationListViewType.LocationListViewType_FavoriteItem.rawValue:
            return self.favoriteInfoArray?.count ?? 0

        default:
            return 0
        }
    }
    
    func tableView(_ tblView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
    
        switch indexPath.section {
            
        case LocationListViewType.LocationListViewType_LocationItem.rawValue:
            cell = self.getLocationItemTableViewCell(tblView, indexPath: indexPath)
            
        case LocationListViewType.LocationListViewType_FavoriteItem.rawValue:
            cell = self.getFavoriteItemTableViewCell(tblView, indexPath: indexPath)
            
        default:
            return cell ?? UITableViewCell()
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case LocationListViewType.LocationListViewType_LocationItem.rawValue:
            return ((self.locationInfoArray?.count ?? 0) > 0) ? 40.0 : 0.0
            
        case LocationListViewType.LocationListViewType_FavoriteItem.rawValue:
            return ((self.favoriteInfoArray?.count ?? 0) > 0) ? 40.0 : 0.0

        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40.0))
        view.backgroundColor = UIColor.white

        let viewSeparator = UIView(frame: CGRect(x: 0, y: 39.0, width: tableView.bounds.size.width, height: 1.0))
        viewSeparator.backgroundColor = UIColor.black
        view.addSubview(viewSeparator)
        
        let lbl = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width-20, height: 40.0))
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.black
        
        switch section {
            
        case LocationListViewType.LocationListViewType_LocationItem.rawValue:
            lbl.text = "Search Results"
            
        case LocationListViewType.LocationListViewType_FavoriteItem.rawValue:
            lbl.text = "Favorites"

        default:
            lbl.text = ""
        }
        
        view.addSubview(lbl)

        return view
    }
    
    //MARK: Table Helper Methods
    
    private func getLocationItemTableViewCell(_ tblView: UITableView, indexPath: IndexPath) -> LocationItemTableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "LocationItemTableViewCell") as! LocationItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self

        guard let locationInfoArray = self.locationInfoArray else {
            return cell
        }
        
        let locationInfo = locationInfoArray[indexPath.row]
        cell.populateData(locationInfo: locationInfo)
        
        return cell
    }
    
    private func getFavoriteItemTableViewCell(_ tblView: UITableView, indexPath: IndexPath) -> FavoriteItemTableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "FavoriteItemTableViewCell") as! FavoriteItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self

        guard let favoriteInfoArray = self.favoriteInfoArray else {
            return cell
        }
        
        let favoriteInfo = favoriteInfoArray[indexPath.row]
        cell.populateData(favoriteInfo: favoriteInfo)

        return cell
    }
}

//MARK: LocationListViewProtocol Methods

extension LocationListViewController: LocationListViewProtocol {
    
    func populateLocationItemArray(locationInfoArray :[LocationInfo]?) {
        self.locationInfoArray = locationInfoArray
        self.tableView.reloadData()
        self.hideLoader()
    }
    
    func populateLocationSearchError() {
        self.locationInfoArray = nil
        self.tableView.reloadData()
        self.hideLoader()
    }
    
    func populateFavoriteItemArray(favoriteInfoArray :[FavoriteInfo]?) {
        self.favoriteInfoArray = favoriteInfoArray
        self.tableView.reloadData()
    }
    
    func populateWeatherReport(favoriteInfo :FavoriteInfo?) {
        guard let favoriteInfoArray = self.favoriteInfoArray, let favoriteInfo = favoriteInfo else {
            return
        }
        
        var indexFavInfo: Int?
        for (index, favInfo) in favoriteInfoArray.enumerated() {
            if let favInfoPlaceID = favInfo.placeID, let placeID = favoriteInfo.placeID, (favInfoPlaceID == placeID) {
                indexFavInfo = index
            }
        }

        if let indexFavInfo = indexFavInfo {
            self.favoriteInfoArray?[indexFavInfo] = favoriteInfo
        }
        
        self.hideLoader()
        self.tableView.reloadData()
    }
}

//MARK: FavoriteItemTableViewCellProtocol Methods

extension LocationListViewController: FavoriteItemTableViewCellProtocol {
    
    func didSelectViewWeatherButton(favoriteInfo: FavoriteInfo?) {
        guard let favoriteInfo = favoriteInfo else {
            return
        }
        
        
        self.view.endEditing(true)
        self.showLoader()
        self.presenter?.getWeatherReport(favoriteInfo: favoriteInfo)
    }
    
    func didSelectDeleteFavoriteButton(favoriteInfo: FavoriteInfo?) {
        guard let favoriteInfo = favoriteInfo else {
            return
        }
        
        FavoriteManager.sharedInstance.deleteLocationFromFavoriteList(favoriteInfo: favoriteInfo)
        self.presenter?.fetchAllFavorite()
    }
}

//MARK: LocationItemTableViewCellProtocol Methods

extension LocationListViewController: LocationItemTableViewCellProtocol {
    
    func didSelectMarkFavoriteButton(locationInfo: LocationInfo?) {
        guard let locationInfo = locationInfo else {
            return
        }
        
        FavoriteManager.sharedInstance.markLocationAsFavorite(locationInfo: locationInfo)
        self.presenter?.fetchAllFavorite()
    }
}
