//
//  ServiceProtocol.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import Foundation
import RxSwift

// Protocol for fetching current weather data
protocol CurrentWeatherServiceProtocol {
    func fetchCurrentWeather(for city: String) -> Observable<WeatherData>
    func fetchMultipleCurrentWeather(for cityIds: [UInt64]) -> Observable<ForecastData>
}

// Protocol for fetching forecast weather data
protocol ForecastWeatherServiceProtocol {
    func fetchForecastWeather(for city: String) -> Observable<ForecastData>
}
