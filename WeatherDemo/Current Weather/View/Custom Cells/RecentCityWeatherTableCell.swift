//
//  RecentCityWeatherTableCell.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 01/10/24.
//

import UIKit

class RecentCityWeatherTableCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var minTempratureLabel: UILabel!
    @IBOutlet weak var maxTempratureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    static let cellIdentifier = "RecentCityWeatherTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
    }
    
    func setupData(data: WeatherData) {
        let cityName = data.cityName
        let temprature = String(format: "%.2f °C", data.temp)
        let tempMax = String(format: "%.2f\n°C", data.tempMax)
        let tempMin = String(format: "%.2f\n°C", data.tempMin)
        let windSpeed = String(format: "%.2f\nmeter/sec", data.windSpeed)
        
        cityNameLabel.text = cityName
        tempratureLabel.text = temprature
        maxTempratureLabel.text = tempMax
        minTempratureLabel.text = tempMin
        windSpeedLabel.text = windSpeed
    }
    
}
