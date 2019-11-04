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

class CitySettingsInterfaceController: WKInterfaceController {

    // MARK: Outlets
    @IBOutlet var savedCityLabel: WKInterfaceLabel!
    @IBOutlet var loadingImage: WKInterfaceImage!
    @IBOutlet var saveButtonLabel: WKInterfaceLabel!

    // MARK: Variables
    var city:String!
    var latitude:String?
    var longitude:String?

    // MARK: API KEYS
    let API_KEY = "361348d124de7eca4866684aeb3d5831"
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
        
        // Get lat long using LocationIQ API (https://api.openweathermap.org/data/2.5/weather?q=Toronto&units=metric&appid=361348d124de7eca4866684aeb3d5831)
        // You can use Google, but you need to give Google your credit card number.
        // You can use the built in Apple CoreLocation library, but this library doesn't work properly with the emulator. See notes below.
        
        
        // TODO: Put your API call here
        
        // Encode the city name
        let cityParam = cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        
        // start showing the loading image
        
        self.loadingImage.setImageNamed("Progress")
        self.loadingImage.startAnimatingWithImages(in: NSMakeRange(0, 10), duration: 1, repeatCount: 0)
        self.saveButtonLabel.setText("Saving...")
        
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?q=\(cityParam!)&units=metric&appid=\(self.API_KEY)&format=json"
//       "https://us1.locationiq.com/v1/search.php?key=\(self.API_KEY)&q=\(cityParam!)&format=json"
        print(URL)
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
            var jsonResponse = JSON(apiData)
            print(jsonResponse)
            let results = jsonResponse.array?.first
            
            if (results == nil) {
                print("Error parsing results from JSON response")
                return
            }
            
            let data = JSON(results)
            self.latitude = data["lat"].string
            self.longitude = data["lon"].string
            
            print("Lat: \(self.latitude)")
            print("Long: \(self.longitude)")
            
            
            // save this to Shared Preferences
            let preferences = UserDefaults.standard
            preferences.set(self.latitude, forKey:"savedLat")
            preferences.set(self.longitude, forKey:"savedLon")
            preferences.set(self.city, forKey:"savedCity")
            
            // dismiss the View Controller
            self.popToRootController()
            
            
            self.loadingImage.stopAnimating()
        }
        
        
        // MARK: Geocoding with CoreLocation libraries
        // -------------
    
        //Note:  This is the code for performing geolocation with the built in CoreLocation library.
        //But, the code doesn't work properly with the watchOS Emulator.
        //It WILL work with a real watch -- just not the simulator.
        //This code remains here for reference purposes
        
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(cityName, completionHandler: {
            
            (placemarks, error) -> Void in
            
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print(coordinates)
            }
        })
        
    }
    
    // MARK: Default functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // get name of city in shared preferences
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
