//
//  CurrentWeatherViewController.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 25/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class CurrentWeatherViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var recentTableView: UITableView!

    @IBOutlet weak var currentWeatherStackView: UIStackView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var maxTempratureLabel: UILabel!
    @IBOutlet weak var minTempratureLabel: UILabel!
    
    //MARK: - Properties
    private var animationView: LottieAnimationView?
    private var viewModel: CurrentWeatherViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrentWeatherViewModel()
        
        setupLottieAnimation()
        setupTableView()
        setupViewsWithRx()
        currentWeatherStackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.fetchRecentCitiesWeather()
    }
    
    //MARK: - Private Methods
    private func setupLottieAnimation() {
        animationView = .init(name: "weather_loading")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        startAnimation()
    }
    
    private func startAnimation() {
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    private func stopAnimation() {
        animationView!.stop()
        animationView?.removeFromSuperview()
    }
    
    private func setupTableView() {
        recentTableView.register(UINib(nibName: "RecentCityWeatherTableCell", bundle: nil), forCellReuseIdentifier: RecentCityWeatherTableCell.cellIdentifier)
    }
    
    private func setupViewsWithRx() {
        /// Manage UI Actions
        viewModel?.uiActions.subscribe(onNext: { [weak self] uiActions in
            guard let self = self else { return }
            
            switch uiActions {
            case .toggleLoading(let isLoading):
                isLoading ? startAnimation() : stopAnimation()
                
            case .showError(let errorMessage):
                self.showAlert(message: errorMessage)
                
            case .showCurrentWeatherData(let weatherData):
                self.showWeatherData(weatherData)
                
            case .showForecastWeatherData(let cityName):
                self.navigateToForecastWeatherViewController(cityName)
            }
        }).disposed(by: disposeBag)
        
        /// Bind forecast data to table view
        viewModel?.recentSearchedWeatherData
            .bind(to: recentTableView.rx.items(cellIdentifier: RecentCityWeatherTableCell.cellIdentifier, cellType: RecentCityWeatherTableCell.self)) { (row, item, cell) in
                cell.setupData(data: item)
            }.disposed(by: disposeBag)
        
        /// Did item selected
        recentTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel?.itemDidSelected(indexPath: indexPath)
            })
            .disposed(by: disposeBag)
    }

    /// Show Error
    private func showAlert(message: String) {
        currentWeatherStackView.isHidden = true
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    /// Show current weather details
    private func showWeatherData(_ data: WeatherData) {
        cityNameLabel.text = data.cityName
        tempratureLabel.text = String(format: "%.2f°", data.temp)
        maxTempratureLabel.text = String(format: "H: %.2f°", data.tempMax)
        minTempratureLabel.text = String(format: "L: %.2f°", data.tempMin)
        if let summary = data.description {
            summaryLabel.text = summary
            summaryLabel.isHidden = false
        } else {
            summaryLabel.isHidden = true
        }
    }
    
    /// Navigate to Forecast weather screen
    private func navigateToForecastWeatherViewController(_ city: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let forecastWeatherVC = storyBoard.instantiateViewController(withIdentifier: "ForecastWeatherViewController") as! ForecastWeatherViewController
        forecastWeatherVC.viewModel = ForecastWeatherViewModel(cityName: city, weatherService: ForecastWeatherAPIService())
        self.show(forecastWeatherVC, sender: self)
    }
}

extension CurrentWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text, !city.isEmpty else { return }
        viewModel?.fetchCurrentWeather(for: city)
        currentWeatherStackView.isHidden = false
        view.endEditing(true)
    }
}
