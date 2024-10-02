//
//  ForecastWeatherTableCell.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 27/09/24.
//

import UIKit

class ForecastWeatherTableCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var minTempratureLabel: UILabel!
    @IBOutlet weak var maxTempratureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    static let cellIdentifier = "ForecastWeatherTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 10
    }
    
    func setupData(data: WeatherData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateString = dateFormatter.string(from: data.date)
        
//        let temprature = String(format: "Temprature: %.2f °C", data.temp)
//        let tempMax = String(format: "Feels like: %.2f °C", data.tempMax)
//        let tempMin = String(format: "Feels like: %.2f °C", data.tempMin)
//        let windSpeed = String(format: "Wind Speed: %.2f meter/sec", data.windSpeed)
        
        let temprature = String(format: "%.2f °C", data.temp)
        let tempMax = String(format: "%.2f\n°C", data.tempMax)
        let tempMin = String(format: "%.2f\n°C", data.tempMin)
        let windSpeed = String(format: "%.2f\nmeter/sec", data.windSpeed)
        
        dayLabel.text = dateString
        tempratureLabel.text = temprature
        maxTempratureLabel.text = tempMax
        minTempratureLabel.text = tempMin
        windSpeedLabel.text = windSpeed
    }
    
}
