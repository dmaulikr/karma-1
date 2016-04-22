//
//  MapViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Parse
import MapKit

class MapViewController: UIViewController {
    
    var sentLocations = Array<CLLocationCoordinate2D>()
    var locationName = ""
    
    @IBOutlet weak var reachMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Your Reach"
        //self.tabBarController?.tabBar.barTintColor = UIColor.whiteColor()
        //let customImage = UIImage.fontAwesomeIconWithName(.Github, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        //self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_icon_normal"), selectedImage: customImage)
        
        let query = PFQuery(className:"Messages")
        query.whereKey("senderId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if (object["recievedLocations"] != nil) {
                            let receivedLocations = object["recievedLocations"] as! Array<PFGeoPoint>
                            for receivedLocation in receivedLocations {
                                let latitude: CLLocationDegrees = receivedLocation.latitude
                                let longtitude: CLLocationDegrees = receivedLocation.longitude
                                
                                let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                                self.sentLocations.append(location)
                            }
                        }
                    }
                }
                self.drawAnnotations()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func drawAnnotations() {
        if self.sentLocations.count > 0 {
            for location in self.sentLocations {
                let annotation = MKPointAnnotation()
                
                
                let geoCoder = CLGeocoder()
                let locationNot2D = CLLocation(latitude: location.latitude, longitude: location.longitude)
                geoCoder.reverseGeocodeLocation(locationNot2D) {
                    (placemarks, error) -> Void in
                    
                    let placeArray = placemarks as [CLPlacemark]!
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    
                    // City
                    if let city = placeMark.addressDictionary?["City"] as? NSString
                    {
                        print(city)
                        self.locationName += city as String
                        self.locationName += ", "
                    }
                    
                    
                    // Country
                    if let country = placeMark.addressDictionary?["Country"] as? NSString
                    {
                        print(country)
                        self.locationName += country as String
                    }
                    annotation.title = self.locationName
                    annotation.coordinate = location
                    self.reachMap.addAnnotation(annotation)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

