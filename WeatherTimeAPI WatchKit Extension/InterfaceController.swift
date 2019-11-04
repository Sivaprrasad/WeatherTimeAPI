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
    @IBOutlet var sunriseLabel: WKInterfaceLabel!
    @IBOutlet var sunsetLabel: WKInterfaceLabel!
    @IBOutlet var cityLabel: WKInterfaceLabel!
    
    @IBOutlet var loadingSunriseImage: WKInterfaceImage!
    @IBOutlet var loadingSunsetImage: WKInterfaceImage!
    
    
    // MARK: variables
    var cityCoordinates:CLLocationCoordinate2D?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let preferences = UserDefaults.standard
        
        print("SHARED PREFERENCES OUTPUT")
        print(preferences.string(forKey: "savedLat"))
        print(preferences.string(forKey: "savedLon"))
        print(preferences.string(forKey: "savedCity"))
        
        
        var lat = preferences.string(forKey:"savedLat")
        var lon = preferences.string(forKey:"savedLon")
        var city = preferences.string(forKey:"savedCity")
        
        if (lat == nil || lon == nil || city == nil) {
            lat = "35"
            lon = "139"
            city = "London"
           
        }
        
        // Update UI
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
