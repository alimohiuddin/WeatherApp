//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Ali Mohiuddin on 31/05/23.
//

import Foundation
import UIKit


class ApiManager {
    
    static let shared = ApiManager()
    private init(){}
    
    // MARK: - Weather Api Key
    struct WeatherApiKey{
        static let weatherDataKey : String = "bcebff3840fab88990159bf1bf487f18"
    }
    
    // MARK: - Weather Api URL
    struct ApiEndPoints{
        
        static var weatherDataUrl : String = "https://api.openweathermap.org/data/2.5/weather?"
        static let GetImageUrl : String = "https://openweathermap.org/img/wn/"
        static let GetWeatherByCity : String = "https://api.openweathermap.org/geo/1.0/direct?"
    }
    
    // MARK: - Weather Api Call
    func getDataFromWeatherApi(lat : Double,long : Double, completionHandler:@escaping(Result<WeatherDataModal,Error>)-> Void){
        
        guard let url = URL(string: ApiEndPoints.weatherDataUrl.appending("lat=\(lat)&lon=\(long)&appid=\(WeatherApiKey.weatherDataKey)&units=imperial")) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error{
                completionHandler(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode(WeatherDataModal.self, from: data)
                    completionHandler(.success(result))
                }catch {
                    completionHandler(.failure(error))
                }
            }else {
                completionHandler(.failure(error!))
            }
            
        }.resume()
        
    }
    
    // MARK: - Weather Geocoding Api Call
    
    func getSearchCities(searchCity : String?,completionHandler:@escaping(Result<[SearchModal],Error>)-> Void){
        let urlStr = ApiEndPoints.GetWeatherByCity.appending("q=\(String(describing: searchCity ?? "")),US&limit=5&appid=\(WeatherApiKey.weatherDataKey)")
        guard let url = URL(string: urlStr)else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                completionHandler(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([SearchModal].self, from: data)
                    completionHandler(.success(result))
                }catch {
                    completionHandler(.failure(error))
                }
            }else {
                completionHandler(.failure(error!))
            }
            
        }.resume()
        
    }
    
    func convertTimestampToDateString(timeStamp : Int?)-> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp ?? 0))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd, hh:mm a"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    
    
    
    
    
}
