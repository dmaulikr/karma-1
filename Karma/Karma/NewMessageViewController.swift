//
//  NewMessageViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class NewMessageViewController: UIViewController {
    
    var messageBody = "This is my message body woooo"
    var currentUser = PFUser.currentUser()
    var selectedAudience = "Berkeley"
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //gameScore.addUniqueObjectsFromArray(["flying", "kungfu"], forKey:"skills")
    //gameScore.saveInBackground()
    
    override func viewDidAppear(animated: Bool) {
        addNewMessage()
        print("ran")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewMessage() {
        
        var displayError = ""
        if messageBody == "" {
            displayError = "Please enter a positive message!"
        } else if currentUser!["location"] == nil {
            //works
            displayError = "Can't find your location!"
        }
        
        if displayError != "" {
            displayAlert("Incomplete Form", displayError: displayError)
        } else {
        
            let newMessage = PFObject(className:"Messages")
        
            newMessage["senderId"] = currentUser!.objectId
            newMessage["sentLocation"] = currentUser!["location"] as! PFGeoPoint
            newMessage["messageBody"] = messageBody
            newMessage["sentDate"] = NSDate()
            newMessage["authorized"] = false
            newMessage["audience"] = selectedAudience
            newMessage["flagged"] = false
        
            //Fields to be changed later:
            //newMessage["readIds"] = Array
            //newMessage["replyText"] = String
        
            let recieverIds = NSMutableArray()
            let recievedLocations = NSMutableArray()
            
            // User's location
            let userGeoPoint = currentUser!["location"] as! PFGeoPoint
            
            let query = PFQuery(className:"_User")
            query.whereKey("location", nearGeoPoint:userGeoPoint)
            query.limit = currentUser!["audienceLim"] as! Int
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) nearby users.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            recieverIds.addObject(object.objectId!)
                            recievedLocations.addObject(object["location"])
                        }
                        newMessage["recieverIds"] = recieverIds
                        newMessage["recievedLocations"] = recievedLocations
                        
                        
                        newMessage.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                print("sucesssss!!!!")
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                // There was a problem, check error.description
                                
                                displayError = "Please try again later!"
                                
                                self.displayAlert("Could Not Send Message", displayError: displayError)
                            }
                        }
                        
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
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
