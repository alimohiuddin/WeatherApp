//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Zibew on 31/05/23.
//

import Foundation

struct WeatherDataModal : Codable{
    
    let coord : Coord?
    let weather : [Weather]?
    let base : String?
    let visibility : Int?
    let dt : Int?
    let timezone: Int?
    let id : Int?
    let name : String?
    let cod : Int?
    let main: Main?
    let rain : Rain?
    let wind : Wind?
    let clouds : Clouds?
    let sys : Sys?
      
    
}

struct Coord : Codable{
    let lon : Double?
    let lat : Double?
}
struct Weather : Codable{
    let id: Int?
    let main : String?
    let description: String?
    let icon: String?
}
struct Main : Codable{
    
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
    let sea_level: Double?
    let grnd_level: Double?
    
}
struct Wind : Codable{
    let speed : Double?
    let deg : Int?
    let gust : Double?
}
struct Rain : Codable{
    let rainHour : Int?
    init(rainHour: Int?) {
        self.rainHour = rainHour
    }
    
    enum codingKeys : String , CodingKey{
        case rainHour = "1h"
    }
}
struct Clouds : Codable{
    let all : Int?
}
struct Sys : Codable{
    let type ,id , sunrise ,sunset : Int?
    let country: String?
}
