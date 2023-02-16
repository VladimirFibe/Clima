import UIKit
import CoreLocation

class ClimaViewController: UIViewController {
    let buttonSizeSmall = 44.0
    let buttonSizelarge = 120.0
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    let backgroundView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView(image: UIImage(named: "background")))
    
    lazy var locationButton: UIButton = {
        $0.setImage( UIImage(systemName: "location.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    lazy var searchButton: UIButton = {
        $0.setImage( UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    let searchField: UITextField = {
        $0.placeholder = "Search"
        $0.textAlignment = .right
        $0.autocapitalizationType = .words
        $0.returnKeyType = .go
        $0.font = .systemFont(ofSize: 25)
        $0.backgroundColor = .systemFill
        $0.borderStyle = .roundedRect
        return $0
    }(UITextField())
    
    let conditionImageView: UIImageView = {
        $0.tintColor = UIColor(named: "wheatherColor")
        return $0
    }(UIImageView(image: UIImage(systemName: "cloud", withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))))
    
    let temperatureLabel: UILabel = {
        $0.text = "21°C"
        $0.font = .systemFont(ofSize: 80, weight: .bold)
        $0.textColor = UIColor(named: "wheatherColor")
        return $0
    }(UILabel())
    
    let cityLabel: UILabel = {
        $0.text = "London"
        $0.font = .systemFont(ofSize: 30)
        $0.textColor = UIColor(named: "wheatherColor")
        return $0
    }(UILabel())
    
    lazy var searchStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [locationButton, searchField, searchButton]))
    
    lazy var stack: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
        $0.spacing = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [
        searchStack,
        conditionImageView,
        temperatureLabel,
        cityLabel]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureAppearance()
        
        searchField.delegate = self
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

extension ClimaViewController {
    func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(stack)
    }
    
    func layoutViews() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.topAnchor.constraint(equalTo: margins.topAnchor),
            stack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            searchStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            searchStack.trailingAnchor.constraint(equalTo: stack.trailingAnchor),

            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureAppearance() {
        
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
