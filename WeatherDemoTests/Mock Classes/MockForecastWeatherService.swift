//
//  MockForecastWeatherService.swift
//  WeatherDemoTests
//
//  Created by Bhavik Modi on 01/10/24.
//

import RxSwift
@testable import WeatherDemo

class MockForecastWeatherService: ForecastWeatherServiceProtocol {
    var forecastWeatherResult: ForecastData?
    var forecastWeatherError: Error?
    
    func fetchForecastWeather(for city: String) -> Observable<ForecastData> {
        if let error = forecastWeatherError {
            return Observable.error(error)
        } else if let forecastData = forecastWeatherResult {
            return Observable.just(forecastData)
        }
        return Observable.empty()
    }
}
