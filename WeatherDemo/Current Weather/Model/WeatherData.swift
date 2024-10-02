//
//  WeatherData.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import Foundation

/// Custom Model with required parameters
struct WeatherData {
    var cityId: UInt64
    var cityName: String
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    var feelsLike: Double
    var date: Date
    var humidity: Double
    var windSpeed: Double
    var description: String?
}

/// Response Model
struct WeatherResponse: Decodable {
    var id: UInt64
    var name: String
    var weather: [Weather]
    var main: MainResponse
    var wind: WindResponse
    var dt: Double
    
    struct CoordinateResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct Weather: Decodable {
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

/// Map to custom model
extension WeatherResponse {
    func mapToModel() -> WeatherData {
        
        let date = Date(timeIntervalSince1970: dt)

        return WeatherData(
            cityId: id,
            cityName: name,
            temp: main.temp,
            tempMin: main.temp_min,
            tempMax: main.temp_max,
            feelsLike: main.feels_like,
            date: date,
            humidity: main.humidity,
            windSpeed: wind.speed,
            description: weather.first?.description ?? ""
        )
    }
}
