//
//  SentExpandVC.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/25/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse
import MapKit


class SentExpandVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var replies = Array<PFObject>()
    var message: PFObject?
    var sentLocations = Array<CLLocationCoordinate2D>()
    var locationName = ""
    
    
    @IBOutlet weak var reachMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        var query = PFQuery(className:"Replies")
        query.whereKey("authorized", equalTo: true)
        query.whereKey("flagged", notEqualTo: true)
        query.whereKey("messageId", equalTo: message!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.replies.append(object)
                        print(object["replyBody"] as! String)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.collectionView.reloadData()
        }
        
        var recievedLocations = message!["recievedLocations"] as! Array<PFGeoPoint>
        for receivedLocation in recievedLocations {
            let latitude: CLLocationDegrees = receivedLocation.latitude
            let longtitude: CLLocationDegrees = receivedLocation.longitude
            
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            self.sentLocations.append(location)
        }
        self.drawAnnotations()
        
//        let query = PFQuery(className:"Messages")
//        query.whereKey("senderId", equalTo: (PFUser.currentUser()?.objectId)!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
//                        if (object["recievedLocations"] != nil) {
//                            let receivedLocations = object["recievedLocations"] as! Array<PFGeoPoint>
//                            for receivedLocation in receivedLocations {
//                                let latitude: CLLocationDegrees = receivedLocation.latitude
//                                let longtitude: CLLocationDegrees = receivedLocation.longitude
//                                
//                                let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
//                                self.sentLocations.append(location)
//                            }
//                        }
//                    }
//                }
//                self.drawAnnotations()
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
        
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replies.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let sm = collectionView.dequeueReusableCellWithReuseIdentifier("originalSentMessage", forIndexPath: indexPath) as! OriginalSentMessageCollectionViewCell
            
            sm.layer.borderWidth = 1
            sm.layer.shadowOffset = CGSizeMake(0, 1)
            sm.layer.shadowColor = UIColor(netHex:0xCDBA96).CGColor
            sm.layer.shadowRadius = 3
            sm.layer.cornerRadius = 3
            sm.backgroundColor = UIColor(netHex: 0xF9A75E)
            sm.layer.borderColor = UIColor.clearColor().CGColor
            //sm.layer.shadowOpacity = 0.7
            
            let shadowFrame: CGRect = (sm.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            sm.layer.shadowPath = shadowPath
            sm.clipsToBounds = false
            
            sm.sentMessageText.text = message!["messageBody"] as! String
            sm.sentMessageDate.text = "Sent " + cleanTime(message!["sentDate"] as! NSDate)
            //placeholder
            return sm
            
        } else {
            let replyCell = collectionView.dequeueReusableCellWithReuseIdentifier("reply", forIndexPath: indexPath) as! ReplyCollectionViewCell
            
            //design cell
            replyCell.layer.borderColor = UIColor.whiteColor().CGColor
            replyCell.layer.borderWidth = 1
            replyCell.layer.shadowOffset = CGSizeMake(0, 1)
            replyCell.layer.shadowColor = UIColor(netHex:0xCDBA96).CGColor
            replyCell.layer.shadowRadius = 3
            replyCell.layer.cornerRadius = 3
            
            replyCell.layer.shadowOpacity = 0.7
            
            let shadowFrame: CGRect = (replyCell.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            replyCell.layer.shadowPath = shadowPath
            replyCell.clipsToBounds = false
            
            
            
            
            if replies.count > 0 {
                replyCell.replyBody.text = replies[indexPath.row]["replyBody"] as? String
                replyCell.replyDate.text = "Replied " + cleanTime(replies[indexPath.row]["replyDate"] as! NSDate)
                //                sc.audience.text = locations[indexPath.item]
                //                sc.timeStamp.text = cleanTime(sentTimes[indexPath.row])
            }
            return replyCell
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        //        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.sectionInset = UIEdgeInsetsMake(-10, 0, 0, 0);
        let frame : CGRect = self.view.frame
        return UIEdgeInsetsMake(10, -30, 0, -30) // margin between cells
    }
    
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        if indexPath.section == 0 {
//            //Bigger one
//            return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 200);
//        } else {
//            return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 115)
//        }
//    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGFloat()
        let labelWidth = UIScreen.mainScreen().bounds.width - 40
        if (indexPath.section == 0) {
            let labelHeight = MDBSwiftUtils.getMultiLineLabelHeight(message!["messageBody"] as! String, maxWidth: Int(labelWidth), font: UIFont.systemFontOfSize(14))
            
            size = 140 + labelHeight - 46 + 20
        } else {
            let labelHeight = MDBSwiftUtils.getMultiLineLabelHeight(replies[indexPath.item]["replyBody"] as! String, maxWidth: Int(labelWidth), font: UIFont.systemFontOfSize(14))
            
            size = 100 + labelHeight - 46 + 20
        }
        return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, size)
        
    }
    
    
    func cleanTime(sentDate: NSDate) -> String {
        
        var timeInterval : NSTimeInterval = sentDate.timeIntervalSinceNow
        timeInterval = timeInterval * -1
        
        //print(timeInterval)
        if timeInterval < 60 {
            return "Just now"
        } else if timeInterval < (60 * 60) {
            let numMinutes = Int(floor(timeInterval / 60))
            return String(numMinutes) + " minutes ago"
        } else if timeInterval < (2*60*60) {
            return "1 hour ago"
        } else if timeInterval < (24*60*60) {
            let numHours = Int(floor(timeInterval / (60*60)))
            return String(numHours) + " hours ago"
        } else if timeInterval < (48 * 60 * 60) {
            return "1 day ago"
        } else if timeInterval < (7 * 24 * 60 * 60) {
            let numDays = Int(floor(timeInterval / (24*60*60)))
            return String(numDays) + " days ago"
        } else if timeInterval < (2 * 7 * 24 * 60 * 60) {
            return "1 week ago"
        } else if timeInterval < (30 * 24 * 60 * 60) {
            let numWeeks = Int(floor(timeInterval / (7*24*60*60)))
            return String(numWeeks) + " weeks ago"
        } else if timeInterval < (2 * 30 * 24 * 60 * 60) {
            return "1 month ago"
        } else if timeInterval < (365 * 24 * 60 * 60) {
            let numMonths = Int(floor(timeInterval / (30*24*60*60)))
            return String(numMonths) + " months ago"
        } else if timeInterval < (365 * 24 * 60 * 60) {
            return "1 year ago"
        }
        
        let numYears = Int(floor(timeInterval / (365*24*60*60)))
        return String(numYears) + " years ago"
        
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
