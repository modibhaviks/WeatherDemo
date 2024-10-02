//
//  ForecastData.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 27/09/24.
//

import Foundation

/// Custom Model with required parameters
struct ForecastData {
    let list: [WeatherData]
}

/// Response Model
struct ForecastResponse: Decodable {
    let list: [ForecastWeatherResponse]
    let city: CityResponse?
    
    struct ForecastWeatherResponse: Decodable {
        var weather: [Weather]
        var main: MainResponse
        var wind: WindResponse
        var dt: Double
        let id: UInt64?
        let name: String?
        
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
        
        func mapToModel() -> WeatherData {
            
            let date = Date(timeIntervalSince1970: dt)

            return WeatherData(
                cityId: id ?? 0,
                cityName: name ?? "",
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
    
    struct CityResponse: Decodable {
        let id: UInt64?
        let name: String?
        let country: String
        let timezone: UInt64
        let sunrise: UInt64
        let sunset: UInt64
    }
}




/// Map to custom model
extension ForecastResponse {
    func mapToModel(isForecast: Bool) -> ForecastData {
        let list = list.map({$0.mapToModel()})
        
        /// Manage data to get weather from multiple cities
        if !isForecast {
            return ForecastData(list: list)
        }
        else {
            /// Manage data for 5 days forcast
            let groupedWeather = Dictionary(grouping: list) { (weather) -> Date in
                // Group by the start of the day
                let calendar = Calendar.current
                return calendar.startOfDay(for: weather.date)
            }
            
            var forcastList = [WeatherData]()
            for (date, weatherArray) in groupedWeather {
                let weatherArrayCount = Double(weatherArray.count)
                
                /// Calculate average temprature for a day
                let avgTemp = weatherArray.map{ $0.temp }.reduce(0, +) / weatherArrayCount
                let avgTempMin = weatherArray.map{ $0.tempMin }.reduce(0, +) / weatherArrayCount
                let avgTempMax = weatherArray.map{ $0.tempMax }.reduce(0, +) / weatherArrayCount
                let avgFeelsLike = weatherArray.map{ $0.feelsLike }.reduce(0, +) / weatherArrayCount
                let avgHumidity = weatherArray.map{ $0.humidity }.reduce(0, +) / weatherArrayCount
                let avgWindSpeed = weatherArray.map{ $0.windSpeed }.reduce(0, +) / weatherArrayCount
                
                forcastList.append(
                    WeatherData(
                        cityId: weatherArray.first?.cityId ?? city?.id ?? 0,
                        cityName: weatherArray.first?.cityName ?? city?.name ?? "",
                        temp: avgTemp,
                        tempMin: avgTempMin,
                        tempMax: avgTempMax,
                        feelsLike: avgFeelsLike,
                        date: date,
                        humidity: avgHumidity,
                        windSpeed: avgWindSpeed
                    )
                )
            }
            return ForecastData(list: forcastList.sorted(by: {$0.date < $1.date}))
        }
    }
}
