//
//  CurrentWeatherService.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import Foundation
import RxSwift

class CurrentWeatherAPIService: CurrentWeatherServiceProtocol {

    private let apiKey = WebServiceConstants.apiKey
    private let baseURL = WebServiceConstants.baseURL

    func fetchCurrentWeather(for city: String) -> Observable<WeatherData> {
        let urlString = "\(baseURL)/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        return NetworkManager.shared.request(from: urlString).map { (response: WeatherResponse) in
            return response.mapToModel()
        }
    }
    
    func fetchMultipleCurrentWeather(for cityIds: [UInt64]) -> Observable<ForecastData> {
        let cityIdString = cityIds.map({String($0)}).joined(separator: ",")
        let urlString = "\(baseURL)/group?id=\(cityIdString)&appid=\(apiKey)&units=metric"
        
        return NetworkManager.shared.request(from: urlString).map { (response: ForecastResponse) in
            response.mapToModel(isForecast: false)
        }
    }
}
