//
//  NewPostCollectionViewCell.swift
//  Karma
//
//  Created by Jessica Ji on 4/6/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

protocol NewPostCollectionViewDelegate {
    func selectLocationsPressed(cell : NewPostCollectionViewCell)
    func parentShouldShowAlert(string:String, title:String)
    func refreshParentCollectionView()
}

class NewPostCollectionViewCell: UICollectionViewCell, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var setAudience: UIButton!
    //let dropDown = DropDown()
    
    @IBOutlet weak var sendButton: UIButton!
    var selectedAudience = "Berkeley"
    var currUser:PFUser? = PFUser.currentUser()
    
    
    @IBOutlet weak var textView: UITextView!
    var usersInRange = Array<PFObject>()
    
    var delegate:NewPostCollectionViewDelegate? = nil
    var canHitSend = true
    
    var characterLimit = 270
    
    @IBOutlet weak var characterLimitLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        //        dropDown.dataSource = [
        //            "Berkeley",
        //            "California"
        //        ]
        //
        //        dropDown.selectionAction = { [unowned self] (index, item) in
        ////            self.setAudience.setTitle(item, forState: .Normal)
        //            print("Selected Action: %@", item)
        //        }
        //        dropDown.anchorView = setAudience
        //        dropDown.direction = .Top
        ////        dropDown.bottomOffset = CGPoint(x: 0, y:setAudience.bounds.height)
        //        dropDown.topOffset = CGPoint(x: 0, y:-setAudience.bounds.height)
        
        
    }
    
    //    @IBAction func showOrDismiss(sender: AnyObject) {
    //        dropDown.reloadAllComponents()
    //
    //        if dropDown.hidden {
    //            dropDown.show()
    //        } else {
    //            dropDown.hide()
    //        }
    //    }
    
    //    @IBAction func viewTapped() {
    //        view.endEditing(false)
    //    }
    
    @IBAction func selectLocationPressed(sender: AnyObject)
    {
        //Present setAudiencepopover and select location
        //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("locationSelection") as! LocationsViewController
        //        var nav = UINavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //        var popover = nav.popoverPresentationController
        //        vc.preferredContentSize = CGSizeMake(320,300)
        //        popover!.delegate = self
        //        popover!.sourceView = self.setAudience
        //        popover!.sourceRect = self.setAudience.frame
        //
        ////        self.presentViewController(nav, animated: true, completion: nil)
        //        self.window?.rootViewController?.presentViewController(nav, animated: true, completion: nil)
        delegate!.selectLocationsPressed(self)
    }
    @IBAction func sendMessage(sender: AnyObject) {
        
        if canHitSend {
            print(textView.text)
            canHitSend = false;
            
            if (textView.text != "" || textView.text != "What's on your mind?") {
                currUser?.incrementKey("audienceLim", byAmount: 0.2)
                currUser!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }
                let msg = PFObject(className: "Messages")
                msg["messageBody"] = textView.text
                
                if (currUser!["location"] == nil) {
                    delegate!.parentShouldShowAlert("We cannot find your location", title: "No Location")
                    return;
                }
                
                if textView.text.characters.count > characterLimit {
                    delegate!.parentShouldShowAlert("It seems like you have a tad bit too many characters in your message! Make it a little shorter.", title: "Woah!")
                    return;
                }
                
                msg["sentLocation"] = currUser!["location"] as! PFGeoPoint
                msg["senderId"] = currUser!.objectId
                msg["sentDate"] = NSDate()
                msg["authorized"] = false
                msg["flagged"] = false
                msg["favorited"] = false
                if (DataStorage.getDouble("radius") == 20.0) {
                    msg["sentScale"] = "Local"
                } else if (DataStorage.getDouble("radius") == 200.0) {
                    msg["sentScale"] = "Mid-Range"
                } else {
                    msg["sentScale"] = "Expansive"
                }
                
                //            msg["audience"] = selectedAudience
                
                //Edit once approved:
                //msg["readIds"] = Array<ObjectIds>
                //msg["replyText"] = String
                
                let recieverIds = NSMutableArray()
                let recievedLocations = NSMutableArray()
                
                let userGeoPoint = currUser!["location"] as! PFGeoPoint
                
                let query = PFQuery(className:"_User")
                print(DataStorage.getDouble("radius"))
                query.whereKey("location", nearGeoPoint:userGeoPoint, withinMiles: DataStorage.getDouble("radius"))
                query.limit = currUser!["audienceLim"] as! Int
                print(currUser!["audienceLim"] as! Int)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if let objects = objects {
                            if objects.count == 0 {
                                // display alert
                                self.delegate!.parentShouldShowAlert("Please select a larger range to pay the posivity forward!", title: "No Users in Range")
                            } else {
                                for object in objects {
                                    if (object.objectId != self.currUser?.objectId) {
                                        recieverIds.addObject(object.objectId!)
                                        recievedLocations.addObject(object["location"])
                                    }
                                }
                                msg["recieverIds"] = recieverIds
                                msg["recievedLocations"] = recievedLocations
                                
                                
                                msg.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    self.setPlaceholder()
                                    self.textView.endEditing(true)
                                    if (success) {
                                        print("yaaaaas")
                                        self.canHitSend = true;
                                        
                                        var currUserAudLim = self.currUser!["audienceLim"] as! Int
                                        var audLimString = ""
                                        if currUserAudLim == 1 {
                                            audLimString = "1 person!"
                                        } else {
                                            audLimString = String(currUserAudLim) + " people!"
                                        }
                                        var sendString = "Your message is on its way to approval! It will be sent to " + audLimString
                                        self.delegate!.parentShouldShowAlert(sendString, title: "Sent!")
                                        self.delegate!.refreshParentCollectionView()
                                        // if tap outside then shrink the box
                                        // but if inside then expand and show the button
                                    } else {
                                        print("error saving")
                                        // display what kind of error?
                                    }
                                }
                            }
                        }
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
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
    }
    
    func setPlaceholder() {
        textView.delegate = self
        textView.text = "What's on your mind?"
        textView.textColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //
        //        dropDown.dataSource = [
        //            "Berkeley",
        //            "California"
        //        ]
        //
        //        dropDown.selectionAction = { [unowned self] (index, item) in
        //            //            self.setAudience.setTitle(item, forState: .Normal)
        //            print("Selected Action: %@", item)
        //        }
        //        dropDown.anchorView = setAudience
        //        dropDown.direction = .Bottom
        //        dropDown.topOffset = CGPoint(x: 0, y:-30)
        
//        var currUserAudLim = currUser!["audienceLim"] as! Int
//        sendButton.titleLabel?.text = String(format: "Send(%i People)", currUserAudLim)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidChange(textView: UITextView) {
        var charactersLeft = characterLimit - textView.text.characters.count
        if charactersLeft < 0 {
            characterLimitLabel.textColor = UIColor.redColor()
        } else {
            characterLimitLabel.textColor = UIColor.lightGrayColor()
        }
        characterLimitLabel.text = String(charactersLeft)
    }
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    
    
    
    
    //dismiss keyboard
    
}
