//
//  ViewController.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import UIKit
import Stevia

final class ViewController: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView()
    private var cities = ["Челябинск", "Курск"]
    private var displayedCities: [String] = []
    private var temperatures: [String: Double] = [:]
    private var discriptions: [String: String] = [:]
    private var editButton = UIBarButtonItem()
    private let searchCityController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchCityController()
        configureTableView()
        configureEditButton()
        getWeatherData()
        
        displayedCities = cities
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
    
    // MARK: - Search Controller Configure
    private func configureSearchCityController() {
        searchCityController.searchResultsUpdater = self
        searchCityController.searchBar.placeholder = "Найти город"
        navigationItem.searchController = searchCityController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchCityController.searchBar.delegate = self
    }
    
    
    //MARK: - Methods
    private func getWeatherData() {
        for city in cities {
            ApiManager.shared.getWeather(for: city) { [weak self] weather in
                DispatchQueue.main.async {
                    self?.temperatures[city] = weather.main?.temp
                    self?.discriptions[city] = weather.weather?[0].description
                    self?.reloadTableData()
                }
            }
        }
    }
    
    private func reloadTableData() {
        if searchCityController.isActive && !searchCityController.searchBar.text!.isEmpty {
            tableView.reloadData()
        } else {
            displayedCities = cities
            tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    @objc func editTable() {
        tableView.isEditing = !tableView.isEditing
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "City", for: indexPath)
        cell.selectionStyle = .none
        let city = displayedCities[indexPath.row]
        let temperature = temperatures[city]
        var content = cell.defaultContentConfiguration()
        content.text = city
        if let temperature = temperature {
            content.secondaryText = "\(temperature)˚C"
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = displayedCities[indexPath.row]
        if searchCityController.isActive && !searchCityController.searchBar.text!.isEmpty {
            if !cities.contains(selectedCity) {
                cities.append(selectedCity)
                getWeatherData()
            }
            searchCityController.searchBar.text = ""
            searchCityController.isActive = false
            
            if displayedCities.count != 0 {
                editButton.isHidden = false
            }
            
        } else {
            let city = displayedCities[indexPath.row]
            navigationController?.pushViewController(DetailViewController(city: city, temperature: temperatures[city] ?? 0.0, discription: discriptions[city] ?? ""), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = displayedCities[indexPath.row]
            temperatures.removeValue(forKey: city)
            discriptions.removeValue(forKey: city)
            displayedCities.remove(at: indexPath.row)
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            if displayedCities.count == 0 {
                editButton.isHidden = true
            }
        }
    }
    
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
                
        guard let text = searchCityController.searchBar.text, !text.isEmpty else { return }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            if !text.isEmpty {
                ApiManager.shared.getWeather(for: text) { [weak self] Weather in
                    DispatchQueue.main.async {
                        if !self!.cities.contains(text) {
                            self?.displayedCities = [text]
                        }
                        self?.tableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.displayedCities = self?.cities ?? []
                    self?.tableView.reloadData()
                }
            }
        })
        
        
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isEditing = false //!!!
        displayedCities = []
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        displayedCities = cities
        tableView.reloadData()
    }
}
