//
//  ViewController.swift
//  WeatherTimeAPI
//
//  Created by Uppalapati SivaPrrasad on 30/10/19.
//  Copyright © 2019 Uppalapati SivaPrrasad. All rights reserved.
//

import UIKit
import WatchConnectivity
import Alamofire
import SwiftyJSON
import CoreLocation


class ViewController: UIViewController, WCSessionDelegate {
    
    var cityCoordinates:CLLocationCoordinate2D?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
                let URL = "https://api.openweathermap.org/data/2.5/weather?q=Toronto&units=metric&appid=361348d124de7eca4866684aeb3d5831"
                
                Alamofire.request(URL).responseJSON {
                    // 1. store the data from the internet in the
                    // response variable
                    response in
                    
                    // 2. get the data out of the variable
                    guard let apiData = response.result.value else {
                        print("Error getting data from the URL")
                        return
                    }
                    
                    // OUTPUT the entire json response to the terminal
                    print(apiData)
                    
                    
                    // GET sunrise/sunset time out of the JSON response
                    let jsonResponse = JSON(apiData)
                    let cityName = jsonResponse["name"].stringValue
                    let currentTemp = jsonResponse["main"]["temp"].stringValue
                    let maxTemp = jsonResponse["main"]["temp_max"].stringValue
                    let minTemp = jsonResponse["main"]["temp_min"].stringValue
                    let humidity = jsonResponse["main"]["humidity"].stringValue
//                    let cloudiness = jsonResponse["clouds"]["all"].stringValue
                    let desc = jsonResponse["weather"][0]["description"].stringValue
                    
                    
//                    let tempStatus = jsonResponse["results"]["weather"][1].string
        
                    
                    
                    // DEBUG:  Output it to the terminal
                    print("City Name: \(cityName)")
                    print("Current Temperature: \(currentTemp)")
                    print("Maximum Temperature: \(maxTemp)")
                    print("Minimum Temperature: \(minTemp)")
                    print("Humidity: \(humidity)")
//                    print("Cloudiness: \(cloudiness)")
                    print("Description: \(desc)")
                }
            
    }
    
//    func geocode(cityName:String) {
//        let geocoder = CLGeocoder()
//        print("Trying to geocode \(cityName) to lat/lon")
//        geocoder.geocodeAddressString(cityName) {
//
//            (placemarks, error) in
//
//            print("Got a response")
//            // Process Response
//            if let error = error {
//                print("Unable to Forward Geocode Address (\(error))")
////                self.savedCityLabel.text = "Unable to Find Location for Address"
//                self.cityCoordinates = nil
//            } else {
//                var location: CLLocation?
//
//                if let placemarks = placemarks, placemarks.count > 0 {
//                    location = placemarks.first?.location
//                    self.cityCoordinates = location?.coordinate
//                }
//
//                if let location = location {
//                    self.cityCoordinates = location.coordinate
//
//                } else {
//                    print("No matching location found")
////                    self.savedCityLabel.text = "No Matching Location Found"
//                    self.cityCoordinates = nil
//                }
//            }
//
//            print("City coordinates: \(self.cityCoordinates)")
//        }
//    }


}

