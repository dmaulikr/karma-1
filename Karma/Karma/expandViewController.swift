//
//  expandViewController.swift
//  karma2
//
//  Created by Jared Gutierrez on 4/2/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import MapKit
import Parse

class expandViewController: UIViewController {
    @IBOutlet weak var response: UITextField!
    @IBOutlet weak var receivedmessage: UILabel!

    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    var message = PFObject()
    var replyOpenText = false
    var currentUser = PFUser.currentUser()
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addNewReply() {
        
        var displayError = ""
        if response.text == "" {
            displayError = "Please enter a positive reply!"
        }
        
        if displayError != "" {
            displayAlert("Incomplete Form", displayError: displayError)
        } else {
            
            let replyText = response.text
            
            let newReply = PFObject(className:"Replies")
            
            newReply["senderId"] = currentUser!.objectId
            newReply["messageId"] = message.objectId
            newReply["replyBody"] = replyText
            newReply["createdAt"] = NSDate()
            newReply["authorized"] = false
            
            
            newReply.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("sucesssss!!!!")
                    //self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // There was a problem, check error.description
                    
                    displayError = "Please try again later!"
                    
                    self.displayAlert("Could Not Send Reply", displayError: displayError)
                }
            }

        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.text = message["audience"] as? String
        let messDate = (message["sentDate"] as? NSDate)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let dateString = dateFormatter.stringFromDate(messDate)
        date.text = dateString
        receivedmessage.text = message["messageBody"] as? String
        if replyOpenText {
            response.becomeFirstResponder()
            print("wwwwwwwoooootttt")
        }
      

        // Do any additional setup after loading the view.
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
    @IBAction func sendReply(sender: AnyObject) {
        addNewReply()
        displayAlert("Sent", displayError: "Reply Sent!")
        response.text = ""
        view.endEditing(true)
    }
    
    @IBAction func sendThanks(sender: AnyObject) {
        print("thankssent")
    }
    @IBOutlet weak var mapFrom: MKMapView!

}
