//
//  WDUserDefaults.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 01/10/24.
//

import Foundation


class WDUserDefaults {
    static let shared = WDUserDefaults()

    let Key_RecentCityList = "RecentCityList"
    
    private init() {}
    
    /// Save / Append searched city id
    func addToRecentCities(_ cityId: UInt64) {
        let defaults = UserDefaults.standard
        var cityIDsArray = getRecentCities() ?? []
        if !cityIDsArray.contains(cityId) {
            cityIDsArray.append(cityId)
            defaults.set(cityIDsArray, forKey: Key_RecentCityList)
        }
    }
    
    func getRecentCities() -> [UInt64]? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey:Key_RecentCityList) as? [UInt64]
    }
}
