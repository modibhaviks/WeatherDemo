//
//  ForecastWeatherViewModel.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 27/09/24.
//

import Foundation
import RxSwift

class ForecastWeatherViewModel {
    let cityName: String
    private let weatherService: ForecastWeatherAPIService
    private let disposeBag = DisposeBag()

    /// Observables for binding
    var uiActions = PublishSubject<UIActionType>()
    let forecastWeatherData = PublishSubject<[WeatherData]>()

    init(cityName: String, weatherService: ForecastWeatherAPIService) {
        self.weatherService = weatherService
        self.cityName = cityName
    }
    
    func fetchForecastWeather(for city: String) {
        uiActions.onNext(.toggleLoading(true))
        
        weatherService.fetchForecastWeather(for: city)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.uiActions.onNext(.toggleLoading(false))
                self?.forecastWeatherData.onNext(data.list)
            }, onError: { [weak self] error in
                self?.uiActions.onNext(.toggleLoading(false))
                self?.uiActions.onNext(.showError(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
    
    enum UIActionType {
        case
        toggleLoading(Bool),
        showError(String)
    }
}
