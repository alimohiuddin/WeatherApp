//
//  LocationManager.swift
//
//  Created by Ali on 23/04/20.
//  Copyright © 2020. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications
import UIKit

var startDateTime = Date()

var locationInstance: CLLocationManager {
    struct Static {
        static let instance: CLLocationManager = CLLocationManager()
    }
    return Static.instance
}

private let _instance = MyLocationManager()
private var timer = Timer()
private var previousLocation = CLLocation()
private var newLocation = CLLocation()
private var frequencyInMins = 1
private var distanceFilterMeters = 25
private var desiredAccuracyMeters =  25
private var cLLocationAccuracy  = "kCLLocationAccuracyNearestTenMeters"
private var timerUpdated = false
private var locationAccessStatus: LocationAuthorizationStatus!

class MyLocationManager: NSObject {
    class var applicationInstance: MyLocationManager {
        return _instance
    }
    var window = UIWindow()
    var locationTimesstamp : Double = 0.0
    var vpos : Int = 0
    var coordinatesArray : [[String : Any]] = []
    var myLocation = CLLocation()

    func askForPermission() {
        locationInstance.delegate = self
        locationInstance.requestWhenInUseAuthorization()
    }
    
    func showSetting(ViewController : UIViewController){
        let alertController = UIAlertController (title: "Please enable location for better result!", message: "", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            ViewController.present(alertController, animated: true)
    }
    
    func manageLocationLocation() {
        
        let locationX = CLLocation.init(latitude: 0.0, longitude: 0.0)
        let location: CLLocation = (locationInstance.location ?? locationX)
        locationInstance.startUpdatingLocation()
        if location.coordinate.latitude != 0.0 {
            previousLocation = newLocation
        }
    }
    
    @objc func updateLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            //LocationAuthorizationStatus = "authorizedWhenInUse"
            locationAccessStatus = LocationAuthorizationStatus.AuthorizedWhenInUse
            self.manageLocationLocation()
            
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationAccessStatus = LocationAuthorizationStatus.AuthorizedAlways
            self.manageLocationLocation()
        } else if CLLocationManager.authorizationStatus() == .denied {
            locationAccessStatus = LocationAuthorizationStatus.Denied
        } else if  CLLocationManager.authorizationStatus() == .restricted {
            locationAccessStatus = LocationAuthorizationStatus.Restricted
        } else if  CLLocationManager.authorizationStatus() == .notDetermined{
            locationAccessStatus = LocationAuthorizationStatus.NotDetermined
        }
    }
    
}
extension MyLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let userLocation: CLLocation = locations[0] as CLLocation
          newLocation = userLocation
        myLocation = userLocation
       }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
               if CLLocationManager.isRangingAvailable() {
                  } else {
                  }
                }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAccessGiven"), object: nil, userInfo: nil)}

            if status == .authorizedWhenInUse {
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAccessGiven"), object: nil, userInfo: nil)
               
            }
            if status == .denied {
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAccessCancelled"), object: nil, userInfo: nil)
            }
        }

    func locationAccuracy(value: LocationAccuracy) -> CLLocationAccuracy {
        switch value {
        case .kCLLocationAccuracyBestForNavigation:
            return kCLLocationAccuracyBestForNavigation
        case .kCLLocationAccuracyBest:
            return kCLLocationAccuracyBest
        case .kCLLocationAccuracyNearestTenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .kCLLocationAccuracyHundredMeters:
            return kCLLocationAccuracyHundredMeters
        case .kCLLocationAccuracyKilometer:
            return kCLLocationAccuracyKilometer
        case .kCLLocationAccuracyThreeKilometers:
            return kCLLocationAccuracyThreeKilometers
        }
     }
   }
enum LocationAccuracy: String {
    case kCLLocationAccuracyBestForNavigation
    case kCLLocationAccuracyBest
    case kCLLocationAccuracyNearestTenMeters
    case kCLLocationAccuracyHundredMeters
    case kCLLocationAccuracyKilometer
    case kCLLocationAccuracyThreeKilometers
}

enum LocationAuthorizationStatus: String {
    case NotDetermined
    case Restricted
    case Denied
    case AuthorizedAlways
    case AuthorizedWhenInUse
}
