//
//  Flickr.swift
//  WeatherAppSwift
//
//  Created by Timofey Lavrenyuk on 11/23/16.
//  Copyright © 2016 Timofey Lavrenyuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol FlickrDelegate {
    func updateBackground(image: UIImage)
    func failure()
}

class Flickr {
    
    var delegate: FlickrDelegate!
    
    let key = "cfd214e4dc870b2a80bebb64dfffd993"
    let url = "https://api.flickr.com/services/rest/"
    
    func getImages(tag: String) {
    
        let params = ["api_key": key, "method": "flickr.photos.search", "tags": tag, "page": 1, "format": "json", "nojsoncallback": 1] as [String : Any]
        
        request(params: params as [String : AnyObject]?)
        
    }
 
    func request(params: [String: AnyObject]?) {
        
        Alamofire.request(url, parameters: params).responseJSON {
            response -> Void in
            
            if response.response?.statusCode != 200 {
                self.delegate.failure()
            } else {
                
                let json = JSON(data: response.data!)
                
                let photo = json["photos"]["photo"][0].dictionary
                
                let imageUrl = self.getImageUrlFromFlickrImageUrl(farm: (photo?["farm"]?.int)!, serverId: (photo?["server"]?.string)! , photoId: (photo?["id"]?.string)! , secret: (photo?["secret"]?.string)!)
                print(imageUrl)
                let image = self.getImageFromUrl(url: imageUrl)
                
                DispatchQueue.main.async {
                    self.delegate.updateBackground(image: image)
                }
                
            }
        }
        
    }
    
    private func getImageUrlFromFlickrImageUrl(size: String = "m", farm: Int, serverId: String, photoId: String, secret: String) -> String {
        //https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        return String("https://farm\(farm).staticflickr.com/\(serverId)/\(photoId)_\(secret)_\(size).jpg")!
    }
    
    func getImageFromUrl(url: String) -> UIImage {
        
        let url = URL(string: url )
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        return image!
        
    }
    
}
