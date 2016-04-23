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
    
    var transferedmessage = ""
    var transfereddate = ""
    var transferedlocation = ""
    var messageId = ""
    var replyOpenText = false
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addNewMessage() {
        
        var displayError = ""
        if response.text == "" {
            displayError = "Please enter a positive reply!"
        }
        
        if displayError != "" {
            displayAlert("Incomplete Form", displayError: displayError)
        } else {
            
            let replyText = response.text
            
            let query = PFQuery(className:"Messages")
            query.getObjectInBackgroundWithId(messageId) {
                (message: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let message = message {
                    message["replyText"] = replyText
                    message.saveInBackground()
                }
            }

        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.text = transferedlocation
        date.text = transfereddate
        receivedmessage.text = transferedmessage
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
        addNewMessage()
        displayAlert("Sent", displayError: "Reply Sent!")
        response.text = ""
        view.endEditing(true)
    }
    
    @IBAction func sendThanks(sender: AnyObject) {
        print("thankssent")
    }
    @IBOutlet weak var mapFrom: MKMapView!

}
