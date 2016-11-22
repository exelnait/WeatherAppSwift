//
//  ViewController.swift
//  WeatherAppSwift
//
//  Created by Timofey Lavrenyuk on 11/22/16.
//  Copyright © 2016 Timofey Lavrenyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherDelegate {
    
    var weather = Weather()
    
    @IBOutlet weak var icon: UIImageView!
    @IBAction func cityButton(_ sender: AnyObject) {
        showCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weather.delegate = self
    }
    
    func showCity() {
        
        let alert = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in
            
            if let textField = alert.textFields?.first as? UITextField? {
                self.weather.getWeatherForCity(city: (textField?.text)!)
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
    
    func updateWeatherInfo() {
        print(weather.city)
    }

}

