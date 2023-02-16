import UIKit
import CoreLocation

class ClimaViewController: UIViewController {

    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private let climaView = ClimaView()
    private let backgroundView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView(image: UIImage(named: "background")))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureAppearance()
        
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

extension ClimaViewController {
    func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(climaView)
    }
    
    func layoutViews() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            climaView.topAnchor.constraint(equalTo: margins.topAnchor),
            climaView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            climaView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            climaView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    func configureAppearance() {
        climaView.configure(self,
                            action: #selector(locationPressed),
                            delegate: self)
    }
}

// MARK: - UITextFiledDelegate

extension ClimaViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        climaView.setCityLabel(textField.text)
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        textField.text = ""
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
            self.climaView.setTemperature(weather.temperatureString)
            self.climaView.setContionImage(weather.condition)
            self.climaView.setCityLabel(weather.city)
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
