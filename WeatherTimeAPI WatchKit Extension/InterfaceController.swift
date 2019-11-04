//
//  InterfaceController.swift
//  WeatherTimeAPI WatchKit Extension
//
//  Created by Uppalapati SivaPrrasad on 30/10/19.
//  Copyright © 2019 Uppalapati SivaPrrasad. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class InterfaceController: WKInterfaceController {

    // MARK: Outlets
   
    @IBOutlet var cityLabel: WKInterfaceLabel!
    @IBOutlet weak var currentTempLabel: WKInterfaceLabel!
    @IBOutlet weak var maxTempLabel: WKInterfaceLabel!
    
    @IBOutlet weak var minTempLabel: WKInterfaceLabel!
    
    @IBOutlet weak var humidityLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptLabel: WKInterfaceLabel!
    
    // MARK: variables
//    var cityCoordinates:CLLocationCoordinate2D?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
//        let preferences = UserDefaults.standard
//
//        print("SHARED PREFERENCES OUTPUT")
//        print(preferences.string(forKey: "savedLat"))
//        print(preferences.string(forKey: "savedLon"))
//        print(preferences.string(forKey: "savedCity"))
//
//
//        var lat = preferences.string(forKey:"savedLat")
//        var lon = preferences.string(forKey:"savedLon")
//        var city = preferences.string(forKey:"savedCity")
//
//        if (lat == nil || lon == nil || city == nil) {
//            lat = "35"
//            lon = "139"
//            city = "London"
//
//        }
        
//         Update UI
//         self.cityLabel.setText(city)
        
        // start animations
//        self.showLoadingAnimations()
        
        // TODO: Put your API call here
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?q=Toronto&units=metric&appid=361348d124de7eca4866684aeb3d5831"
        print("Url: \(URL)")
        Alamofire.request(URL).responseJSON {
            // 1. store the data from the internet in the
            // response variable
            response in
            
            // 2. get the data out of the variable
            guard let apiData = response.result.value else {
                print("Error getting data from the URL")
                return
            }
            
            print(apiData)
            
            // GET sunrise/sunset time out of the JSON response
            let jsonResponse = JSON(apiData)
            let cityName = jsonResponse["name"].stringValue
            let currentTemp = jsonResponse["main"]["temp"].stringValue
            let maxTemp = jsonResponse["main"]["temp_max"].stringValue
            let minTemp = jsonResponse["main"]["temp_min"].stringValue
            let humidity = jsonResponse["main"]["humidity"].stringValue
            let desc = jsonResponse["weather"][0]["description"].stringValue
            
            // DEBUG:  Output it to the terminal
            print("City Name: \(cityName)")
            print("Current Temperature: \(currentTemp)")
            print("Maximum Temperature: \(maxTemp)")
            print("Minimum Temperature: \(minTemp)")
            print("Humidity: \(humidity)")
            print("Description: \(desc)")
            
            // display in a UI
            self.cityLabel.setText("\(cityName)")
            self.currentTempLabel.setText("Temperature: \(currentTemp)'C")
            self.maxTempLabel.setText("Max Temperature: \(maxTemp)'C")
            self.minTempLabel.setText("Min Temperature: \(minTemp)'C")
            self.humidityLabel.setText("Humidity: \(humidity) % ")
            self.descriptLabel.setText("\(desc)")

        }
    }
   
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    // MARK: Actions
    @IBAction func changeCityButtonPressed() {
        
    }
    
    
}
