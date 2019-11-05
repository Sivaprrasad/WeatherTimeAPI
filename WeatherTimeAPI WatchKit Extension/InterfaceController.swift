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
    @IBOutlet weak var localTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var currentTempLabel: WKInterfaceLabel!
    @IBOutlet weak var feelsLikeLabel: WKInterfaceLabel!
    
    @IBOutlet weak var precipLabel: WKInterfaceLabel!
    
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
         
        let URL = "http://api.weatherstack.com/current?access_key=ef9c9bf3475dc1e23bf5b28914c12fbf&query=toronto&units=m"
        

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
            let cityName = jsonResponse["location"]["name"].stringValue
            let lTime = jsonResponse["location"]["localtime"].stringValue
            let currentTemp = jsonResponse["current"]["temperature"].stringValue
            let feelsLike = jsonResponse["current"]["feelslike"].stringValue
//            let minTemp = jsonResponse["main"]["temp_min"].stringValue
            let humidity = jsonResponse["current"]["humidity"].stringValue
            let precipitation = jsonResponse["current"]["precip"].stringValue
            let desc = jsonResponse["current"]["weather_descriptions"][0].stringValue
//            let time = jsonResponse
            
            // DEBUG:  Output it to the terminal
            print("City Name: \(cityName)")
            print("Local Date And Time: \(lTime)")
            print("Current Temperature: \(currentTemp)")
            print("Feels Like: \(feelsLike)")
            print("Precipitation: \(precipitation)")
            print("Humidity: \(humidity)")
            print("Description: \(desc)")
            
            // display in a UI
            
            self.cityLabel.setText("\(cityName)")
            self.localTimeLabel.setText("\(lTime)")
            self.currentTempLabel.setText("\(currentTemp)°C")
            self.feelsLikeLabel.setText("\(feelsLike)°C")
            self.precipLabel.setText("\(precipitation)")
            self.humidityLabel.setText("\(humidity) % ")
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
