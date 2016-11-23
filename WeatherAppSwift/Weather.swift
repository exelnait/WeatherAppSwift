//
//  Weather.swift
//  WeatherAppSwift
//
//  Created by Timofey Lavrenyuk on 11/22/16.
//  Copyright © 2016 Timofey Lavrenyuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

protocol WeatherDelegate {
    func updateWeatherInfo(weather: JSON)
    func failure()
}

class Weather {
    
    let url = "https://api.apixu.com/v1/current.json"
    let key = "5c40c72b9b544023b9b74029162111"
    
    var delegate: WeatherDelegate!
    
    func getWeatherFor(city: String) {
        
        let params = ["q" : city, "key": key]
        
        request(params: params as [String : AnyObject]?)
    }
    
    func getWeatherFor(coords: CLLocationCoordinate2D) {
        
        let q = "\(coords.latitude),\(coords.longitude)"
        let params = ["q" : q, "key": key]
        
        request(params: params as [String : AnyObject]?)
    }
    
    func request(params: [String: AnyObject]?) {
        
        Alamofire.request(url, parameters: params).responseJSON {
            response -> Void in
            
            if response.response?.statusCode != 200 {
                self.delegate.failure()
            } else {
                
                let weather = JSON(data: response.data!)
                
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo(weather: weather)
                }
                
            }
        }
        
    }
    
    func timeFromUnux(time: Int) -> String {
        
        let timeInSecond = TimeInterval(time)
        let date = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date as Date)
        
    }
    
    func weatherIcon(url: String) -> UIImage {
        
        let url = URL(string: "https:\(url)")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let image = UIImage(data: data!)
        
        return image!
        
    }
    
    func convertTermperature(country: String, temperature: Double) -> Double {
        
        if country == "United States of America" {
            return round(temperature * 1.8 + 32)
        } else {
            return temperature
        }
        
    }
    
}
