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

protocol WeatherDelegate {
    func updateWeatherInfo()
}

class Weather {
    
    let url = "https://api.apixu.com/v1/current.json"
    let key = "5c40c72b9b544023b9b74029162111"
    
    var city: String?
    var temp: Int?
    var description: String?
    //    var time: String?
//    var icon: UIImage?
    
    var delegate: WeatherDelegate!
    
    
    
//    init() {
//        
//        let location = json["location"] as! NSDictionary
//        let current = json["current"] as! NSDictionary
//        let condition = current["condition"] as! NSDictionary
//        
//        city = location["name"] as! String
//        description = condition["text"] as! String
//        
//        temp = current["temp_c"] as! Int
//        
//        let date = current["last_updated_epoch"] as! Int
//        time = timeFromUnux(time: date)
//        
//        let iconUrl = condition["icon"] as! String
//        icon = weatherIcon(url: iconUrl)
//        
//    }
    
    func getWeatherForCity(city: String) {
        
        let parameters = ["q" : city, "key": key]
        
        Alamofire.request(url, parameters: parameters).responseJSON {
            response -> Void in
            
            if response.response?.statusCode != 200 {
                print("Error")
            } else {
                
                let weather = JSON(data: response.data!)
                
                if let city = weather["location"]["name"].string {
                    self.city = city
                }
                if let description = weather["current"]["condition"]["text"].string {
                    self.description = description
                }
                if let temp = weather["current"]["temp_c"].int {
                    self.temp = temp
                }
                
                
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo()
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
    
}
