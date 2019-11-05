//
//  CitySettingsInterfaceController.swift
//  WeatherTimeAPI WatchKit Extension
//
//  Created by Uppalapati SivaPrrasad on 01/11/19.
//  Copyright © 2019 Uppalapati SivaPrrasad. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class CityChangeInterfaceController: WKInterfaceController {

    // MARK: Outlets
    @IBOutlet var savedCityLabel: WKInterfaceLabel!
    @IBOutlet var loadingImage: WKInterfaceImage!
    @IBOutlet var saveButtonLabel: WKInterfaceLabel!

    // MARK: Variables
    var city:String!


    // MARK: API KEYS
    let API_KEY = "ef9c9bf3475dc1e23bf5b28914c12fbf"
    var mainVC:InterfaceController?
    
    @IBAction func selectCityPressed() {
        // 1. When person clicks on button, show them the input UI
        let suggestedResponses = ["Toronto", "Montreal","New York City","Los Angeles"]
        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain) {
            
            (results) in
            
            if (results != nil && results!.count > 0) {
                // 2. write your code to process the person's response
                let userResponse = results?.first as? String
                self.savedCityLabel.setText(userResponse)
                self.city = userResponse
            }
        }
    }
    
    @IBAction func saveButtonPressed() {
        print("Getting City")
        self.geocode(cityName: self.city)
    }
 
    
    func geocode(cityName:String) {
        
        // TODO: Put your API call here
        // Encode the city name
        let cityParam = cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    
        
        let URL = "http://api.weatherstack.com/current?access_key=\(self.API_KEY)&query=\(cityParam!)&units=m"
        
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
            // Get the lat/long component out of the response url
            let jsonResponse = JSON(apiData)
            print(jsonResponse)
            
            let results = jsonResponse.array?.first
            
            if (results == nil) {
                print("Error parsing results from JSON response")
                return
            }
            
            let data = JSON(results)
            self.city = data["location"]["name"].string
//            self.latitude = data["lat"].string
//            self.longitude = data["lon"].string
            print("Name: \(self.city)")
//            print("Lat: \(self.latitude)")
//            print("Long: \(self.longitude)")
            
            
            // save this to Shared Preferences
            let preferences = UserDefaults.standard
            
            preferences.set(self.city, forKey:"savedCity")

            // dismiss the View Controller
            self.popToRootController()
        
        }
        
    }
    
    // MARK: Default functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
//        get name of city in shared preferences
        
        let preferences = UserDefaults.standard
        guard let savedCity = preferences.string(forKey: "savedCity") else {
            return
        }

        self.savedCityLabel.setText(savedCity)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
