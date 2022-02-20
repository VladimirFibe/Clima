//
//  ClimaViewController.swift
//  Clima
//
//  Created by Vladimir Fibe on 18.02.2022.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController {
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()
  
  let backgroundView = UIImageView(image: UIImage(named: "background"))
  let locationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage( UIImage(systemName: "location.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 40).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
    return button
  }()
  
  let searchButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage( UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 40).isActive = true
    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
    return button
  }()
  
  let searchField: UITextField = {
    let text = UITextField()
    text.placeholder = "Search"
    text.textAlignment = .right
    text.autocapitalizationType = .words
    text.returnKeyType = .go
    text.font = .systemFont(ofSize: 25)
    text.backgroundColor = .systemFill
    text.borderStyle = .roundedRect
    return text
  }()
  
  let conditionImageView: UIImageView = {
    let imageview = UIImageView(image: UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120)))
    imageview.tintColor = UIColor(named: "wheatherColor")
    return imageview
  }()
  
  let temperatureLabel: UILabel = {
    let label = UILabel()
    label.text = "21°C"
    label.font = .systemFont(ofSize: 80, weight: .bold)
    label.textColor = UIColor(named: "wheatherColor")
    return label
  }()
  
  let cityLabel: UILabel = {
    let label = UILabel()
    label.text = "London"
    label.font = .systemFont(ofSize: 30)
    label.textColor = UIColor(named: "wheatherColor")
    return label
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searchField.delegate = self
    weatherManager.delegate = self
    conditionImageView.image = UIImage(systemName: "sun.max", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  func setupUI() {
    view.addSubview(backgroundView)
    backgroundView.contentMode = .scaleAspectFill
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    let searchStack = UIStackView(arrangedSubviews: [locationButton, searchField, searchButton])
    searchStack.axis = .horizontal
    searchStack.alignment = .fill
    searchStack.distribution = .fill
    searchStack.spacing = 10
    let emptyView = UIView()
    let stack = UIStackView(arrangedSubviews: [
      searchStack,
      conditionImageView,
      temperatureLabel,
      cityLabel,
      emptyView])
    stack.axis = .vertical
    stack.alignment = .trailing
    stack.distribution = .fill
    stack.spacing = 10
    
    view.addSubview(stack)
    let margins = view.layoutMarginsGuide
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    stack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    stack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    stack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    searchStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
    searchStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
  }
  
  @objc func searchPressed(_ sender: UIButton) {
    searchField.endEditing(true)
  }
  
  @objc func locationPressed(_ sender: UIButton) {
    locationManager.requestLocation()
  }
}
  
  // MARK: - UITextFiledDelegate

extension ClimaViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchField.endEditing(true)
    print("hide keyboard and launch search")
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    cityLabel.text = searchField.text
    if let city = searchField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    searchField.text = ""
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text == "" {
      textField.placeholder = "Type something"
      return false
    } else {
      return true
    }
  }
}

// MARK: - WeatherManagerDelegate

extension ClimaViewController: WeatherManagerDelegate {
  
  func didUpdateWeater(_ weather: WeatherModel) {
    DispatchQueue.main.async {
      self.temperatureLabel.text = weather.temperatureString
      self.conditionImageView.image = UIImage(systemName: weather.condition, withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))
      self.cityLabel.text = weather.city
    }
    print(weather.city, weather.temperatureString)
  }
  
  func didFailWithError(_ error: Error) {
    print(error.localizedDescription)
  }
}

extension ClimaViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}
