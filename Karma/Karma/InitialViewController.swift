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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        let userId = currentUser?.objectId
        
        if  currentUser != nil {
            //check for unread messages
            let query = PFQuery(className:"Messages")
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
                            self.performSegueWithIdentifier("toUnread", sender: self)
                        } else {
                            self.loaded = true
                            self.performSegueWithIdentifier("toMain", sender: self)
                        }
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
