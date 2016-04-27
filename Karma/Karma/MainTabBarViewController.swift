//
//  MainTabBarViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class MainTabBarViewController: UITabBarController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentUser = PFUser.currentUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            // Do any additional setup after loading the view.
            selectedIndex = 1;
            
            // Core Location Manager asks for GPS location
            
            // For use in foreground
        
            
            viewControllers![0].tabBarItem.image = UIImage.fontAwesomeIconWithName(.MapO, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
            viewControllers![1].tabBarItem.image = UIImage.fontAwesomeIconWithName(.MailForward, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
            viewControllers![2].tabBarItem.image = UIImage.fontAwesomeIconWithName(.MailReply, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
            viewControllers![3].tabBarItem.image = UIImage.fontAwesomeIconWithName(.Gear, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestLocation()
        } else if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined){
            self.displayAlertLocation()
        }
    }
    
    func displayAlertLocation() {
        let alert = UIAlertController(title: "We Can't Get Your Location", message: "Sincerely needs your location to function. Please grant permission to Sincerely in location settings.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title:"Location Settings", style: UIAlertActionStyle.Default, handler: { action in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.Default, handler: { action in
            self.displayAlertLocation()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            
            let currentGeoPoint = PFGeoPoint(location: location)
            currentUser!["location"] = currentGeoPoint
            currentUser!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("saved")
                } else {
                    // There was a problem, check error.description
                }
            }
        } else {
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            self.displayAlertLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
