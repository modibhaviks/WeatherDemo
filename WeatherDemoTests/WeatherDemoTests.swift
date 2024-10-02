//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by Bhavik Modi on 25/09/24.
//

import XCTest
import RxSwift
@testable import WeatherDemo

final class WeatherDemoTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func testFetchCurrentWeatherSuccess() {
        // Given
        let mockService = MockCurrentWeatherService()
        
        // When
        let result = mockService.fetchCurrentWeather(for: "Ahmedabad")
        
        // Then
        result.subscribe(onNext: { weatherData in
            XCTAssertNotNil(weatherData)
        }).disposed(by: disposeBag)
    }
    
    func testFetchCurrentWeatherError() {
        // Given
        let mockService = MockCurrentWeatherService()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.currentWeatherError = expectedError
        
        // When
        let result = mockService.fetchCurrentWeather(for: "InvalidCity")
        
        // Then
        result.subscribe(onError: { error in
            XCTAssertEqual(error as NSError, expectedError)
        }).disposed(by: disposeBag)
    }
    
    func testFetchForecastWeatherSuccess() {
        // Given
        let mockService = MockForecastWeatherService()
        
        // When
        let result = mockService.fetchForecastWeather(for: "Ahmedabad")
        
        // Then
        result.subscribe(onNext: { forecastData in
            XCTAssertNotNil(forecastData)
        }).disposed(by: disposeBag)
    }
    
    func testFetchForecastWeatherError() {
        // Given
        let mockService = MockForecastWeatherService()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.forecastWeatherError = expectedError
        
        // When
        let result = mockService.fetchForecastWeather(for: "InvalidCity")
        
        // Then
        result.subscribe(onError: { error in
            XCTAssertEqual(error as NSError, expectedError)
        }).disposed(by: disposeBag)
    }
    
    func testFetchCurrentWeatherMultipleCitiesSuccess() {
        // Given
        let mockService = MockCurrentWeatherService()
        
        // When
        let cityIds:[UInt64] = [524901,703448,2643743]
        let result = mockService.fetchMultipleCurrentWeather(for: cityIds)
        
        // Then
        result.subscribe(onNext: { weatherData in
            XCTAssertNotNil(weatherData)
        }).disposed(by: disposeBag)
    }
    
    func testFetchCurrentWeatherMultipleCitiesError() {
        // Given
        let mockService = MockCurrentWeatherService()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.currentWeatherError = expectedError
        
        // When
        let cityIds:[UInt64] = [999999999,10010101010]
        let result = mockService.fetchMultipleCurrentWeather(for: cityIds)
        
        // Then
        result.subscribe(onError: { error in
            XCTAssertEqual(error as NSError, expectedError)
        }).disposed(by: disposeBag)
    }
}
