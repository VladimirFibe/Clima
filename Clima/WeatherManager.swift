//
//  WeatherManager.swift
//  Clima
//
//  Created by Vladimir Fibe on 19.02.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeater(_ weather: WeatherModel)
  func didFailWithError(_ error: Error)
}
struct WeatherManager {
  var delegate: WeatherManagerDelegate?
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=46958494d92dddd02f6d0e45932fa84f&units=metric"
  
  func fetchWeather(cityName: String) {
    let urlString = "\(weatherURL)&q=\(cityName)"
    performRequest(urlString: urlString)
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
    print(urlString)
    performRequest(urlString: urlString)
  }
  func performRequest(urlString: String) {
    // 1. Create URL
    guard let url = URL(string: urlString) else { return }
    
    // 2. Create a URLSession
    let session = URLSession(configuration: .default)
    
    // 3. Give the session a task
    let task = session.dataTask(with: url) { data, response, error in
      if let error = error {
        self.delegate?.didFailWithError(error)
        return
      }
      
      if let safeData = data {
        if let weather = parseJSON(weatherData: safeData) {
          delegate?.didUpdateWeater(weather)
        }
      }
    }
    
    // 4. Start the task
    task.resume()
  }
  
  func parseJSON(weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let city = decodedData.name
      let temperature = decodedData.main.temp
      let weatherModel = WeatherModel(id: id, city: city, temperature: temperature)
      print(decodedData.main.tempMin)
      return weatherModel
    } catch {
      self.delegate?.didFailWithError(error)
      return nil
    }
  }
  
}
