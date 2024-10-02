//
//  CurrentWeatherViewModel.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import Foundation
import RxSwift
import RxRelay

class CurrentWeatherViewModel {
    private let weatherService: CurrentWeatherAPIService
    private let disposeBag = DisposeBag()
    
    /// Observables for binding
    var uiActions = PublishSubject<UIActionType>()
    let currentWeatherData = PublishSubject<WeatherData>()
    let recentSearchedWeatherData = BehaviorRelay(value: [WeatherData]())

    init(weatherService: CurrentWeatherAPIService = CurrentWeatherAPIService()) {
        self.weatherService = weatherService
    }
    
    func fetchRecentCitiesWeather() {
        if let cityIDsArray = WDUserDefaults.shared.getRecentCities(), cityIDsArray.count > 0 {
            uiActions.onNext(.toggleLoading(true))
            weatherService.fetchMultipleCurrentWeather(for: cityIDsArray)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] data in
                    self?.uiActions.onNext(.toggleLoading(false))
                    self?.recentSearchedWeatherData.accept(data.list)
                }, onError: { [weak self] error in
                    self?.uiActions.onNext(.toggleLoading(false))
                    self?.uiActions.onNext(.showError(error.localizedDescription))
                })
                .disposed(by: disposeBag)
        } else {
            uiActions.onNext(.toggleLoading(false))
        }
    }

    func fetchCurrentWeather(for city: String) {
        uiActions.onNext(.toggleLoading(true))
        weatherService.fetchCurrentWeather(for: city)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                /// Update Current weather details for entered city
                self?.uiActions.onNext(.toggleLoading(false))
                self?.uiActions.onNext(.showCurrentWeatherData(data))
                
                /// Update Recent Cities List
                WDUserDefaults.shared.addToRecentCities(data.cityId)
                self?.fetchRecentCitiesWeather()
            }, onError: { [weak self] error in
                self?.uiActions.onNext(.toggleLoading(false))
                self?.uiActions.onNext(.showError(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
    
    func itemDidSelected(indexPath: IndexPath) {
        let cityName = recentSearchedWeatherData.value[indexPath.row].cityName
        uiActions.onNext(.showForecastWeatherData(cityName))
    }
    
    enum UIActionType {
        case
        toggleLoading(Bool),
        showError(String),
        showCurrentWeatherData(WeatherData),
        showForecastWeatherData(_ cityName: String)
    }
}
