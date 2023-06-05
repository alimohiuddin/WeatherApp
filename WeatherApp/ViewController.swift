//
//  ViewController.swift
//  WeatherApp
//
//  Created by Zibew on 31/05/23.
//

import UIKit
import CoreLocation
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewObj: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tepDescriptionLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var climateImageView: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    @IBOutlet weak var densityLbl: UILabel!
    @IBOutlet weak var ultraVauletLbl: UILabel!
    var weatherDataObj : WeatherDataModal?
    var searchResult : [SearchModal] = []
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // MARK: -  Ask for permission
        MyLocationManager.applicationInstance.askForPermission()
        // MARK: -  Notification Observer Methods
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationAccessGiven(_:)), name: NSNotification.Name(rawValue: "locationAccessGiven"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationAccessCancelled(_:)), name: NSNotification.Name(rawValue: "locationAccessCancelled"), object: nil)
        
        // MARK: -  Table Cell Registration
        self.tableViewObj.register(UINib.init(nibName: "WeatherCell", bundle: nibBundle), forCellReuseIdentifier: "WeatherCell")
        self.tableHeight.constant = 0
    }
    // MARK: -  Notification Methods :
    @objc func locationAccessGiven(_ notification: NSNotification) {
        MyLocationManager.applicationInstance.updateLocation()
        self.getWeatherData(lat: MyLocationManager.applicationInstance.myLocation.coordinate.latitude, long: MyLocationManager.applicationInstance.myLocation.coordinate.longitude)
       
   }
    @objc func locationAccessCancelled(_ notification: NSNotification) {
        MyLocationManager.applicationInstance.showSetting(ViewController: self)
   }
    // MARK: -  Api Calling Methods :
    func getWeatherData(lat : Double? , long : Double?){
        ApiManager.shared.getDataFromWeatherApi(lat: lat ?? 0.0,long:long ?? 0.0){ Result in
            switch Result{
            case.success(let result):
                DispatchQueue.main.async {
                    self.updateUi(weatherObj: result)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUi(weatherObj : WeatherDataModal?){
        
        self.nameLbl.text = weatherObj?.name ?? ""
//        self.tempLbl.text = "\(Int(weatherObj?.main?.temp ?? 0.0))°C"
        self.tempLbl.text = "\(String(format: "%.f",weatherObj?.main?.temp ?? 0.0 ))°C"
        let imageUrl = "\(ApiManager.ApiEndPoints.GetImageUrl)\(String(describing: weatherObj?.weather?[0].icon ?? ""))\(".png")"
        self.climateImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
        self.tepDescriptionLbl.text = "Feel Likes \(String(format:"%.f",weatherObj?.main?.temp_max ?? 0))°C, \(weatherObj?.weather?[0].description ?? "")"
        self.humidityLbl.text = "humidity \(weatherObj?.main?.humidity ?? 0)%"
        self.visibilityLbl.text = "Visibility:\(String(describing: (weatherObj?.visibility ?? 0)/1000))Km"
        self.windSpeed.text = "\(weatherObj?.wind?.speed ?? 0.0) m/s"
        self.ultraVauletLbl.text = "UV:\(weatherObj?.sys?.type ?? 0)"
        self.hoursLbl.text = "\(weatherObj?.main?.pressure ?? 0)hpa"
        self.densityLbl.text = "Dew point: "
        self.timeLbl.text = ApiManager.shared.convertTimestampToDateString(timeStamp: weatherObj?.dt ?? 0)
        
    }

}
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    // MARK: -  TableView Datasource and delegate Methods :
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        cell.dataSource(item: item)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.searchResult[indexPath.row]
        self.getWeatherData(lat: item.lat ?? 0.0, long: item.lon ?? 0.0)
        self.searchResult.removeAll()
        self.tableViewObj.reloadData()
        self.tableHeight.constant = 0
        self.nameLbl.text = item.name ?? ""
        self.searchTF.text = ""
    }
}

extension ViewController : UITextFieldDelegate{
    // MARK: -  Text field Delegate :
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        var txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        if txtAfterUpdate.count > 0
        {
            self.searchResult.removeAll()
            self.tableViewObj.reloadData()
            txtAfterUpdate = txtAfterUpdate.components(separatedBy: .whitespacesAndNewlines).joined()
            ApiManager.shared.getSearchCities(searchCity: txtAfterUpdate) { Result in
                switch Result{
                case.success(let result):
                    DispatchQueue.main.async {
                        self.searchResult = result
                        self.tableHeight.constant = 250
                        self.tableViewObj.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        else
        {
            self.tableHeight.constant = 0
            self.searchResult.removeAll()
            self.tableViewObj.reloadData()
        }
        
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}


