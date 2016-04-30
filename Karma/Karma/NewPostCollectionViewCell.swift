//
//  NewPostCollectionViewCell.swift
//  Karma
//
//  Created by Shaan Appel on 4/22/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

protocol NewPostCollectionViewDelegate : class {
    func selectLocationsPressed(cell : NewPostCollectionViewCell)
    func parentShouldShowAlert(string:String, title:String)
    func refreshParentCollectionView()
}

class NewPostCollectionViewCell: UICollectionViewCell, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    let characterLimit = 270
    weak var delegate : NewPostCollectionViewDelegate?
    var canHitSend = true
    var currUser = PFUser.currentUser()
    
    
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var setAudience: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterLimitLabel: UILabel!
    
    
    
    /**
     Iniates parent-defined action when selectLocation is pressed. (Currently creates a popover to allow the user to select a send radius for their message)
     */
    
    
    @IBAction func selectLocationPressed(sender: AnyObject) {
        
        if ((delegate) != nil) {
            delegate!.selectLocationsPressed(self)
        } else {
            print("Something is wrong, this cell's delegate wasn't set...")
        }
    }
    
    /**
     Sends a new message when sendMessage Button is Pressed
     */
    
    @IBAction func sendMessage(sender: AnyObject) {
        if textView.text.characters.count > characterLimit {
            showAlert("It seems like you have a tad bit too many characters in your message! Make it a little shorter.", title: "Woah!")
            
        } else if canHitSend {
            canHitSend = false;
            sendNewMessage()
        }
    }
    
    
    /**
     Binds the cell to a parent view controller
     */
    
    func bind(delegate: NewPostCollectionViewDelegate) {
        self.delegate = delegate
    }
    
    
    
    /**
     Sends the message currently typed
     */
    
    func sendNewMessage() {
        if (textView.text != "" && textView.text != "What's on your mind?") {
            
            //Create Message to send
            let msg = PFObject(className: "Messages")
            
            
            
            //Set Message Fields
            if let userId = currUser?.objectId {
                msg["senderId"] = userId
            } else {
                showAlert("We cannot connect to the internet right now", title: "No Connection")
                return;
            }
            
            if let userLocation = currUser?["location"] {
                msg["sentLocation"] = userLocation as! PFGeoPoint
                msg["messageBody"] = textView.text
                msg["senderId"] = currUser!.objectId
                msg["sentDate"] = NSDate()
                msg["authorized"] = false
                msg["flagged"] = false
                msg["favorited"] = false
                msg["sentScale"] = getCurrentSendRadiusAsString()
                
                findUsersAndSend(msg,userGeoPoint: userLocation as! PFGeoPoint)
            } else {
                showAlert("We cannot find your location", title: "No Location")
                return;
            }
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.sentLabel.alpha = 1.0
                }, completion: nil)
            UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.sentLabel.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
            })
            
        }
    }
    
    
    /**
     Finds appropriate nearby users, and sends the message to them.
     */
    
    func findUsersAndSend(msg: PFObject, userGeoPoint: PFGeoPoint) {
        
        //Set recipients for the message
        let recieverIds = NSMutableArray()
        let recievedLocations = NSMutableArray()
        
        let query = PFQuery(className:"_User")
        query.whereKey("location", nearGeoPoint:userGeoPoint, withinMiles: DataStorage.getDouble("radius"))
        query.limit = currUser!["audienceLim"] as! Int
        query.findObjectsInBackgroundWithBlock {
            (users: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let users = users {
                    if users.count == 0 {
                        // display alert that message won't be sent to any users
                        self.showAlert("Please select a larger range to pay the posivity forward!", title: "No Users in Range")
                    } else {
                        for user in users {
                            if (user.objectId != self.currUser?.objectId) {
                                recieverIds.addObject(user.objectId!)
                                recievedLocations.addObject(user["location"])
                            }
                        }
                        msg["recieverIds"] = recieverIds
                        msg["recievedLocations"] = recievedLocations
                        
                        
                        msg.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            self.setPlaceholder()
                            self.textView.endEditing(true)
                            
                            if (success) {
                                self.canHitSend = true;
                                self.incrementUserAudienceLimit()
                                let sendString = self.getAudienceLimitString()
                                self.showAlert(sendString, title: "Sent!")
                                self.refreshParentCollectionView()
                                
                            } else {
                                self.showAlert("We cannot send you message right now", title: "Send Error")
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
    
    /**
     Sets the placeholder for the message sending textView.
     */
    
    func setPlaceholder() {
        textView.delegate = self
        textView.text = "What's on your mind?"
        textView.textColor = UIColor.lightGrayColor()
    }
    
    
    /**
     Increments the user Audience Limit by 0.2
     */
    
    func incrementUserAudienceLimit() {
        currUser?.incrementKey("audienceLim", byAmount: 0.2)
        currUser?.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("User Audience Limit Incremented")
            } else {
                print("Error incrementing User Audience Limit. Error: " + String(error?.localizedDescription))
            }
        }
    }
    
    
    /**
     Returns the selected send radius as a string.
     */
    
    func getCurrentSendRadiusAsString() -> String {
        if (DataStorage.getDouble("radius") == 20.0) {
            return "Local"
        } else if (DataStorage.getDouble("radius") == 200.0) {
            return "Mid-Range"
        } else {
            return "Expansive"
        }
    }
    
    
    /**
     Refreshes the Collection View of sent messages from the parent view controller
     */
    
    func refreshParentCollectionView() {
        if ((delegate) != nil) {
            delegate!.refreshParentCollectionView()
        } else {
            print("Something is wrong, this cell's delegate wasn't set...")
        }
    }
    
    
    
    /**
     Displays an alert from the parent view controller.
     
     
     - parameters:
     - content: Contents of the alert to be displayed
     - title: Title of the alert to be displayed
     */
    
    func showAlert(content: String, title: String) {
        if ((delegate) != nil) {
            delegate!.parentShouldShowAlert(content, title: title)
        } else {
            print("Something is wrong, this cell's delegate wasn't set...")
        }
    }
    
    
    
    /**
     Returns a string for number of people a message has been sent to.
     */
    
    func getAudienceLimitString() -> String {
        if let currUserAudLim = currUser?["audienceLim"] as? Int {
            var audLimString = ""
            if currUserAudLim == 1 {
                audLimString = "1 person!"
            } else {
                audLimString = String(currUserAudLim) + " people!"
            }
            return "Your message is on its way to approval! It will be sent to " + audLimString
        } else {
            return "Your message is on its way to approval!"
        }
        
        
    }
    
    
    
    /**
     Clears text view upon initial editing.
     */
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    /**
     Changes color of character limit label to red when character limit is reached.
     */
    func textViewDidChange(textView: UITextView) {
        let charactersLeft = characterLimit - textView.text.characters.count
        if charactersLeft < 0 {
            characterLimitLabel.textColor = UIColor.redColor()
        } else {
            characterLimitLabel.textColor = UIColor.lightGrayColor()
        }
        characterLimitLabel.text = String(charactersLeft)
    }
    
    
    
    /**
     Reset text Field
     */
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    
    
    
    //for later use
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
