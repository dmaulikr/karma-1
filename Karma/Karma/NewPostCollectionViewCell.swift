//
//  NewPostCollectionViewCell.swift
//  Karma
//
//  Created by Jessica Ji on 4/6/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class NewPostCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var setAudience: UIButton!
    let dropDown = DropDown()
    
    var selectedAudience = "Berkeley"
    var currUser = PFUser.currentUser()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropDown.dataSource = [
            "Berkeley",
            "California"
        ]
        
//        dropDown.selectionAction = { [unowned self] (index, item) in
//            self.setAudience.setTitle(item, forState: .Normal)
//        }
//        dropDown.anchorView = setAudience
//        dropDown.bottomOffset = CGPoint(x: 0, y:setAudience.bounds.height)
        
    }
    
    @IBAction func showOrDismiss(sender: AnyObject) {
        if dropDown.hidden {
            dropDown.show()
        } else {
            dropDown.hide()
        }
    }
 
//    @IBAction func viewTapped() {
//        view.endEditing(false)
//    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        print(textView.text)
        if (textView.text != "" || textView.text != "What's on your mind?") {
            let msg = PFObject(className: "Messages")
            msg["messageBody"] = textView.text
            msg["sentLocation"] = currUser!["location"] as! PFGeoPoint
            msg["senderId"] = currUser!.objectId
            msg["sentDate"] = NSDate()
            msg["authorized"] = false
            msg["flagged"] = false
            msg["favorited"] = false
            
            msg["audience"] = selectedAudience
            
            //Edit once approved:
            //msg["readIds"] = Array<ObjectIds>
            //msg["replyText"] = String
            
            let recieverIds = NSMutableArray()
            let recievedLocations = NSMutableArray()
            
            let userGeoPoint = currUser!["location"] as! PFGeoPoint
            
            let query = PFQuery(className:"_User")
            query.whereKey("location", nearGeoPoint:userGeoPoint)
            query.limit = currUser!["audienceLim"] as! Int
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            recieverIds.addObject(object.objectId!)
                            recievedLocations.addObject(object["location"])
                        }
                        msg["recieverIds"] = recieverIds
                        msg["recievedLocations"] = recievedLocations
                        
                        
                        msg.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            self.setPlaceholder()
                            self.textView.endEditing(true)
                            if (success) {
                                print("yaaaaas")
                                // if tap outside then shrink the box
                                // but if inside then expand and show the button
                            } else {
                                print("error saving")
                                // display what kind of error?
                            }
                        }
                        
                        
                    }
                } else {
                    print("Error: \(error!) \(error!.userInfo)")
                }
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
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
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
