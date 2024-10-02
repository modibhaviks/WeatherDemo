//
//  ForecastWeatherService.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 27/09/24.
//

import Foundation
import RxSwift

class ForecastWeatherAPIService: ForecastWeatherServiceProtocol {

    private let apiKey = WebServiceConstants.apiKey
    private let baseURL = WebServiceConstants.baseURL

    func fetchForecastWeather(for city: String) -> Observable<ForecastData> {
        let urlString = "\(baseURL)/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        return NetworkManager.shared.request(from: urlString).map { (response: ForecastResponse) in
            return response.mapToModel(isForecast: true)
        }
    }
}
