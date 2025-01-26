//
//  DetailViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

class DetailViewController: UIViewController {
    
    //MARK: - Properties
    private let city: String
    private let temperature: Double
    private let discription: String
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let discriptionLabel = UILabel()
    private var segmentedControl = UISegmentedControl()
    private let tableView = UITableView()
    private var forecast: [ForecastList] = []
    private var filteredForecast: [ForecastList] = []
    
    //MARK: - Init
    init(city: String, temperature: Double, discription: String) {
        self.city = city
        self.temperature = temperature
        self.discription = discription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCityLabel()
        configureTemperatureLabel()
        configureDiscriptionLabel()
        configureSegmentedControl()
        configureTableView()
        
        ApiManager.shared.getForecast(for: city) { [weak self] forecast in
            DispatchQueue.main.async {
                self?.forecast = forecast.list ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Configure UI
    private func configureCityLabel() {
        view.subviews(cityLabel)
        cityLabel.Leading == view.Leading + 24
        cityLabel.Top == view.safeAreaLayoutGuide.Top + 16
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        cityLabel.text = city
    }
    
    private func configureTemperatureLabel() {
        view.subviews(temperatureLabel)
        temperatureLabel.Trailing == view.Trailing - 24
        temperatureLabel.CenterY  == cityLabel.CenterY
        temperatureLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        temperatureLabel.text = "\(temperature)˚C"
    }
    
    private func configureDiscriptionLabel() {
        view.subviews(discriptionLabel)
        discriptionLabel.Leading == view.Leading + 24
        discriptionLabel.Top == cityLabel.Bottom + 8
        discriptionLabel.Width == view.Width / 2
        discriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        discriptionLabel.text = self.discription.uppercased()
        discriptionLabel.numberOfLines = 0
    }
    
    private func configureSegmentedControl() {
        let menuArray = ["3 дня", "5 дней"]
        segmentedControl = UISegmentedControl(items: menuArray)
        view.subviews(segmentedControl)
        segmentedControl.Top == discriptionLabel.Bottom + 16
        segmentedControl.Leading == view.Leading
        segmentedControl.Trailing == view.Trailing
        segmentedControl.addTarget(self, action: #selector(controlChanged), for: .valueChanged)
        
    }
    
    private func configureTableView() {
        view.subviews(tableView)
        tableView.Top == segmentedControl.Bottom + 16
        tableView.Width == view.Width
        tableView.Bottom == view.Bottom
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Forecast")
        tableView.dataSource = self
    }

    //MARK: - Actions
    @objc func controlChanged() {
        let currentDate = Date()
        let timestamp = Double(currentDate.timeIntervalSince1970)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            filteredForecast = forecast.filter { $0.dt! <= timestamp + DaysInSeconds.treeDays }
            tableView.reloadData()
        } else {
            filteredForecast = forecast.filter { $0.dt! <= timestamp + DaysInSeconds.fiveDays }
            tableView.reloadData()
        }
    }

}


//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Forecast", for: indexPath)
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        
        if let timestamp = filteredForecast[indexPath.row].dt {
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd MMMM в HH:mm"
            let dateString = dateFormatter.string(from: date)
            content.text = "\(dateString)"
        }
        
        let temperature = filteredForecast[indexPath.row].main?.temp ?? 0.0
        let discription = filteredForecast[indexPath.row].weather?.first?.description ?? "nodata"
        content.secondaryText = "Ожидается \(temperature)˚C, \(discription)"
        
        content.image = UIImage(named: "\(discription)")
        
        content.imageProperties.maximumSize = CGSizeMake(52, 52)
        content.imageToTextPadding = 48
                                
        cell.contentConfiguration = content
        return cell
    }
    
    
}
