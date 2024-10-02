//
//  ForecastWeatherViewController.swift
//  WeatherDemo
//
//  Created by Bhavik Modi on 27/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class ForecastWeatherViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!

    //MARK: - Properties
    private var animationView: LottieAnimationView?
    var viewModel: ForecastWeatherViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottieAnimation()
        setupTableView()
        setupViewsWithRx()
        setupData()
    }
    
    //MARK: - Private Methods
    private func setupLottieAnimation() {
        animationView = .init(name: "weather_loading")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
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
    
    private func setupData() {
        if let cityName = viewModel?.cityName {
            cityNameLabel.text = cityName
            viewModel?.fetchForecastWeather(for: cityName)
        }
    }
    
    private func setupTableView() {
        forecastTableView.register(UINib(nibName: "ForecastWeatherTableCell", bundle: nil), forCellReuseIdentifier: ForecastWeatherTableCell.cellIdentifier)
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
            }
        }).disposed(by: disposeBag)
        
        /// Bind forecast data to table view
        viewModel?.forecastWeatherData
            .bind(to: forecastTableView.rx.items(cellIdentifier: ForecastWeatherTableCell.cellIdentifier, cellType: ForecastWeatherTableCell.self)) { (row, item, cell) in
                cell.setupData(data: item)
            }.disposed(by: disposeBag)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
