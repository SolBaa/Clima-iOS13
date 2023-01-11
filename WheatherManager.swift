//
//  WheatherManager.swift
//  Clima
//
//  Created by Sol on 1/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


struct WheatherManager {
    let wheatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f830253bca15f51774667fb5d2aa8157&units=metric"
    func fetchWeather(cityName: String){
        let urlString = "\(wheatherURL)&q=\(cityName)"
        perfomRequest(urlString: urlString)
    }
    
    func perfomRequest(urlString: String){
        //1. Create URL
        if let url = URL(string: urlString){
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    self.parseJSON(wheatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(wheatherData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: wheatherData)
            let weatherID = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let weather = WeatherModel(conditionID: weatherID, cityName: cityName, temperaure: temperature)
            let iconImage =  weather.conditionName
            print(iconImage)
        }catch{
            print(error)
        }
        
    }
    
}
