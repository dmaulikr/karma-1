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
        
        
        
        // these are only for screenshot purposes
        let newYorkLocation = CLLocationCoordinate2DMake(40.9000, -120
        )
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "New York City"
        reachMap.addAnnotation(dropPin)
        
        let santacruz = CLLocationCoordinate2DMake(39, -160.0308)
        // Drop a pin
        let dropPin1 = MKPointAnnotation()
        dropPin1.coordinate = santacruz
        dropPin1.title = "New York City"
        reachMap.addAnnotation(dropPin1)
        
        let sanfrancisco = CLLocationCoordinate2DMake(40, -112)
        // Drop a pin
        let dropPin2 = MKPointAnnotation()
        dropPin2.coordinate = sanfrancisco
        dropPin2.title = "San Francisco"
        reachMap.addAnnotation(dropPin2)
        
        let richmond = CLLocationCoordinate2DMake(36, -92)
        // Drop a pin
        let dropPin3 = MKPointAnnotation()
        dropPin3.coordinate = richmond
        dropPin3.title = "richmond"
        reachMap.addAnnotation(dropPin3)
        
        let sanleandro = CLLocationCoordinate2DMake(33, -117)
        // Drop a pin
        let dropPin4 = MKPointAnnotation()
        dropPin4.coordinate = sanleandro
        dropPin4.title = "San Leandro"
        reachMap.addAnnotation(dropPin4)
        
        let halfmoonbay = CLLocationCoordinate2DMake(38, -123)
        // Drop a pin
        let dropPin5 = MKPointAnnotation()
        dropPin5.coordinate = halfmoonbay
        dropPin5.title = "Halfmoon Bay"
        reachMap.addAnnotation(dropPin5)
        
        
        
        
        
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
        query.whereKey("authorized", equalTo: true)
        query.whereKey("flagged", notEqualTo: true)
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
                self.locationName = ""
                let annotation = MKPointAnnotation()
                
                
                let geoCoder = CLGeocoder()
                
                
                //locationNot2D has the same latitudes and longitudes as "location," but
                //is an object of type CLLocation, as opposed to CLLocation2D. The reverse geocoder
                //takes in a CLLocation object.
                let locationNot2D = CLLocation(latitude: location.latitude, longitude: location.longitude)
                geoCoder.reverseGeocodeLocation(locationNot2D) {
                    (placemarks, error) -> Void in
                    
                    let placeArray = placemarks as [CLPlacemark]!
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    
                    // City
                    if let city = placeMark.locality
                    {
                        print(city)
                        self.locationName += city as String
                        self.locationName += ", "
                    }
                    
                    if let state = placeMark.administrativeArea
                    {
                        print(state)
                        self.locationName += state as String
                        self.locationName += ", "
                    }
                    
                    // Country
                    if let country = placeMark.country
                    {
                        print(country)
                        self.locationName += country as String
                    }
                    
                    //These next three lines will add an annotation of the specific location.
                    //Comment out these lines adding an annotation of the
                    //general city.
                    //                    annotation.title = self.locationName
                    //                    annotation.coordinate = location
                    //                    self.reachMap.addAnnotation(annotation)
                    
                    //localLocationName is necessary to hold the value of self.locationName
                    //because self.locationName will be set to nil in the line after this geocodeAddressString block,
                    //before this geocodeAddressString block is done running.
                    var localLocationName = self.locationName
                    var geo = CLGeocoder()
                    geo.geocodeAddressString(localLocationName, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                        if((error) != nil){
                            
                            print("Error", error)
                        }
                            
                        else {
                            var placemark:CLPlacemark = placemarks![0] as! CLPlacemark
                            var coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                            
                            var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                            pointAnnotation.coordinate = coordinates
                            pointAnnotation.title = localLocationName
                            self.reachMap.addAnnotation(pointAnnotation)
                            self.reachMap.centerCoordinate = coordinates
                            self.reachMap.selectAnnotation(pointAnnotation, animated: true)
                            print("Added annotation to map view")
                        }
                    })
                    self.locationName = ""
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

