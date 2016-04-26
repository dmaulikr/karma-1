//
//  InitialViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/12/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class InitialViewController: UIViewController {
    
    var loaded = false
    var messagesToShow = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        let userId = currentUser?.objectId
        
        if  currentUser != nil {
            //check for unread messages
            let query = PFQuery(className:"Messages")
            query.whereKey("authorized", equalTo: true)
            query.whereKey("flagged", notEqualTo: true)
            query.whereKey("recieverIds", equalTo: userId!)
            query.whereKey("readIds", notEqualTo: userId!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) socials.")
                    
                    
                    // Do something with the found objects
                    if let objects = objects {
                        if objects.count > 0 {
                            self.loaded = true
                            self.messagesToShow = objects
                            self.performSegueWithIdentifier("toUnread", sender: self)
                        } else {
                            print("Got right before seguing to the cardstack viewcontroller.")
                            self.loaded = true
                            self.performSegueWithIdentifier("toMain", sender: self)
                        }
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    print("testing login")
                }
            }
        } else {
            //go to signin
            self.loaded = true
            self.performSegueWithIdentifier("toSignIn", sender: self)
            print("WEEEEENNNNNTTTTT TOOOOO SIGGGNNNN INNNNN")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if loaded {
            let currentUser = PFUser.currentUser()
            if  currentUser != nil {
                self.performSegueWithIdentifier("toMain", sender: self)
            } else {
                self.performSegueWithIdentifier("toSignIn", sender: self)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toUnread") {
            let vc = segue.destinationViewController as! CardStackViewController
            vc.messagesToShow = self.messagesToShow as! Array<PFObject>
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
