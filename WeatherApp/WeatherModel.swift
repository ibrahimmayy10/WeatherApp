//
//  ViewController.swift
//  WeatherApp
//
//  Created by İbrahim AY on 17.07.2023.
//


import Foundation

struct WeatherModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Coord: Codable {
    let lat, lon: Double
}

struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility, pop: Int
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: Icon
}

enum Description: String, Codable {
    case clearSky = "clear sky"
}

enum Icon: String, Codable {
    case the01D = "01d"
    case the01N = "01n"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
