import Foundation

struct WeatherData: Decodable {
  let coord: Coord
  let weather: [Weather]
  let base: String
  let main: Main
  let name: String
  let visibility: Int
  let wind: Wind
}

struct Coord: Decodable {
  let lon: Double
  let lat: Double
}

struct Weather: Decodable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}

struct Main: Decodable {
  let temp: Double
  let pressure: Int
  let humidity: Int
  let tempMin: Double
  let tempMax: Double
}

struct Wind: Decodable {
  let speed: Double
  let deg: Int
}
