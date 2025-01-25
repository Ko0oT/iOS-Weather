//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var cities = ["Petrozavodsk", "Kursk"]
    private var temperatures: [String: Double] = ["Petrozavodsk": 25.0, "Kursk": 26.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        ApiManager.shared.getWeather(for: "Курск") { weather in
            print(weather)
        }
    }
    
    //MARK: - Table View Configure
    private func configureTableView() {
        view.subviews(tableView)
        tableView.fillContainer()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "City")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "City", for: indexPath)
        let city = cities[indexPath.row]
        let temperature = temperatures[city] ?? 0.0
        var content = cell.defaultContentConfiguration()
        content.text = city
        content.secondaryText = "\(temperature)˚C"
        cell.contentConfiguration = content
        return cell
    }
    
}
