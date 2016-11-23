//
//  ViewController.swift
//  WeatherAppSwift
//
//  Created by Timofey Lavrenyuk on 11/22/16.
//  Copyright © 2016 Timofey Lavrenyuk. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import CoreLocation

class CurrentWeatherVC: UIViewController, WeatherDelegate, FlickrDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var weatherBackground: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherLocation: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherTime: UILabel!
    @IBOutlet weak var weatherWindSpeed: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var weather = Weather()
    var flickr = Flickr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weather.delegate = self
        self.flickr.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    func showCity() {
        
        let alert = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in
            
            if let textField = alert.textFields?.first as? UITextField? {
                self.weather.getWeatherFor(city: (textField?.text)!)
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField() {
            (textField) -> Void in
            textField.placeholder = "Enter city name here"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateWeatherInfo(weather json: JSON) {
        print(json)
        if let temp = json["current"]["temp_c"].double {
            
            let country = json["location"]["country"].string
            let city = json["location"]["name"].string
            
            self.weatherLocation.text = "\(city!), \(country!)"
            //self.flickr.getImages(tag: "\(city!),\(country!)")
            
            let description = json["current"]["condition"]["text"].string
            self.weatherDescription.text = description
            
            let temperature = weather.convertTermperature(country: country!, temperature: temp)
            self.weatherTemperature.text = "\(temperature)"
            
            let date = json["current"]["last_updated_epoch"].int
            let time = weather.timeFromUnux(time: date!)
            self.weatherTime.text = "At \(time) it is"
            
//            let isDay = json["current"]["is_day"].bool
            
            let iconUrl = json["current"]["condition"]["icon"].string
            let icon = weather.weatherIcon(url: iconUrl!)
            self.weatherIcon.image = icon
            
            let humidity = json["current"]["humidity"].int
            self.weatherHumidity.text = "\(humidity!)"
            
            let wind = json["current"]["wind_kph"].int
            self.weatherWindSpeed.text = "\(wind!)"
            
            print(temperature)
            
        } else {
            print("Load weather Error")
        }
        
    }
    
    func updateBackground(image: UIImage) {
        
        self.weatherBackground.image = image
        
    }

    func failure() {
        
        let alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in
            
            if let textField = alert.textFields?.first as? UITextField? {
                self.weather.getWeatherFor(city: (textField?.text)!)
            }
        }
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var currentLocation = locations.last! as CLLocation
        if (currentLocation.horizontalAccuracy > 0) {
            
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.weather.getWeatherFor(coords: coords)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cant get location")
    }
    
}

