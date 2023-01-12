//
//  WheatherManager.swift
//  Clima
//
//  Created by Sol on 1/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let wheatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f830253bca15f51774667fb5d2aa8157&units=metric"
    var delegate:  WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(wheatherURL)&q=\(cityName)"
        perfomRequest(with: urlString)
    }
   
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(wheatherURL)&lat=\(latitude)&lon=\(longitude)"
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String){
        //1. Create URL
        if let url = URL(string: urlString){
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather =  self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ wheatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: wheatherData)
            let weatherID = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let weather = WeatherModel(conditionID: weatherID, cityName: cityName, temperaure: temperature)
            let iconImage =  weather.conditionName
            print(iconImage)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
