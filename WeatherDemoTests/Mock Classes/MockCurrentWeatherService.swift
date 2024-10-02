//
//  MockCurrentWeatherService.swift
//  WeatherDemoTests
//
//  Created by Bhavik Modi on 01/10/24.
//

import RxSwift
@testable import WeatherDemo

class MockCurrentWeatherService: CurrentWeatherServiceProtocol {
    var currentWeatherResult: WeatherData?
    var currentWeatherError: Error?
    
    func fetchCurrentWeather(for city: String) -> Observable<WeatherData> {
        if let error = currentWeatherError {
            return Observable.error(error)
        } else if let weatherData = currentWeatherResult {
            return Observable.just(weatherData)
        }
        return Observable.empty()
    }
    
    func fetchMultipleCurrentWeather(for cityIds: [UInt64]) -> Observable<ForecastData> {
        // Implement similarly if needed
        return Observable.empty()
    }
}
