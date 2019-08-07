//
//  WeatherViewController.swift
//  Climatic
//
//  Created by Stanislav on 06/08/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    

    
    //TODO: - Declare instance variables
    let locationManager = CLLocationManager()
    
    //MARK: - IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    //MARK: - Networking
    func requestWeather(parameters : [String: String]){
        
        
        var components = URLComponents(string: WEATHER_URL)!
        components.queryItems = parameters.map {
            (key, value) in URLQueryItem(name: key, value: value)
        }
        
        guard let url = components.url else { return }
//        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Connection problem \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Request error : \(response.statusCode)")
                    return
                }
            }

            guard let data = data else {return}
            DispatchQueue.main.async {
                self.parseWeatherData(data: data)
            }
        }.resume()
    }
    
    //MARK: - JSON Parsing
    private func parseWeatherData(data: Data){
        do {
            let weatherData = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            print(weatherData)
            updateUI(weatherData: weatherData)
        }
        catch let error {
            print("Response parsing error \(error)")
        }
    }
    
    //MARK: - UI Updates
    private func updateUI(weatherData: OpenWeatherResponse){
        if let main = weatherData.main, let temperature = main.temp{
            temperatureLabel.text = "\(Int(temperature))"
        }
        if let cityName = weatherData.name {
            cityLabel.text = cityName
        }
        if let weather = weatherData.weather, let conditions = weather[0].id {
            weatherIcon.image = UIImage(named: updateWeatherIcon(condition: conditions))
        }
        
    }
    
    
    //MARK: Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("\(location.coordinate.longitude) \(location.coordinate.latitude)")
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let appid = Keys().APP_ID
            
            let params : [String: String] = ["lat" : "\(latitude)", "lon" : "\(longitude)", "appid" : appid, "units": "metric"]
            requestWeather(parameters: params)

        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something wrong \(error)")
        cityLabel.text = "Location unavailable"
        let alert = UIAlertController(title: "Error",
            message: "You need to allow location access for this app",
            preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Go to settings", comment: "Default action"),
                                          style: .default,
                                          handler: {(_) in
                                            guard let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") else { return }
                                            if UIApplication.shared.canOpenURL(url) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: {(success) in
                                                    print("Settings opened: \(success)")
                                                })
                                            }
                                            
        }
        )
        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_) in
            self.locationManager.startUpdatingLocation()
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Change City Delegate Method
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }


}

