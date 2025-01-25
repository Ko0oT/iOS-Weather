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
    private var cities = ["Челябинск", "Курск"]
    private var temperatures: [String: Double?] = [:]
    private var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureEditButton()
        getWeatherData()
    }
    
    //MARK: - Edit Button Configure
    private func configureEditButton() {
        editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil.circle"), style: .plain, target: self, action: #selector(editTable))
        navigationItem.rightBarButtonItem = editButton
    }
    
    //MARK: - Table View Configure
    private func configureTableView() {
        view.subviews(tableView)
        tableView.fillContainer()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "City")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Fetch Weather Data
    private func getWeatherData() {
        for city in cities {
            ApiManager.shared.getWeather(for: city) { [weak self] weather in
                DispatchQueue.main.async {
                    self?.temperatures[city] = weather.main?.temp
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Edit Table
    @objc func editTable() {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            editButton.image = UIImage(systemName: "square.and.pencil.circle.fill")
        } else {
            editButton.image = UIImage(systemName: "square.and.pencil.circle")
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "City", for: indexPath)
        cell.selectionStyle = .none
        let city = cities[indexPath.row]
        let temperature = temperatures[city]
        var content = cell.defaultContentConfiguration()
        content.text = city
        if let temperature = temperature {
            content.secondaryText = "\(temperature ?? 0)˚C"
        } else {
            content.secondaryText = "Нет данных"
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            temperatures.removeValue(forKey: city)
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            if cities.count == 0 {
                editButton.isHidden = true
            } else {
                editButton.isHidden = false
            }
        }
    }
    
}
