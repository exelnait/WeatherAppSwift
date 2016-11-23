//
//  ForecastWeatherTableViewCell.swift
//  WeatherAppSwift
//
//  Created by Timofey Lavrenyuk on 11/23/16.
//  Copyright © 2016 Timofey Lavrenyuk. All rights reserved.
//

import UIKit

class ForecastWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTime: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
