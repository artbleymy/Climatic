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
    var id: Int?
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

//This method turns a condition code into the name of the weather condition image

    func updateWeatherIcon(condition: Int) -> String {

    switch (condition) {

        case 0...300 :
            return "tstorm1"

        case 301...500 :
            return "light_rain"

        case 501...600 :
            return "shower3"

        case 601...700 :
            return "snow4"

        case 701...771 :
            return "fog"

        case 772...799 :
            return "tstorm3"

        case 800 :
            return "sunny"

        case 801...804 :
            return "cloudy2"

        case 900...903, 905...1000  :
            return "tstorm3"

        case 903 :
            return "snow5"

        case 904 :
            return "sunny"

        default :
            return "dunno"
        }

    }
