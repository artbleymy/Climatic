//
//  WeatherDataModel.swift
//  Climatic
//
//  Created by Stanislav on 06/08/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    var main: String?
    var description: String?
}

struct MainWeather: Decodable {
    var temp: Float?
    var pressure: Float?
    var temp_min: Float?
    var temp_max: Float?
}

struct OpenWeatherResponse: Decodable {
    var name : String?
    var base : String?
    var weather: [Weather]?
    var main: MainWeather?
}
