//
//  WeatherModel.swift
//  Clima
//
//  Created by Vladimir Fibe on 20.02.2022.
//

import Foundation

struct WeatherModel {
  let id: Int
  let city: String
  let temperature: Double
  
  var temperatureString: String {
    String(format: "%.1f°C", temperature)
  }
  var condition: String {
    switch id {
    case 200...232: return "cloud.bolt"
    case 300...321: return "cloud.drizzle"
    case 500...531: return "cloud.rain"
    case 600...622: return "cloud.snow"
    case 700...781: return "cloud.fog"
    case 800: return "sun.max"
    case 801...804: return "cloud.bolt"
    default: return "cloud"
    }
  }
}
