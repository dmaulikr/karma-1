//
//  changeUsernameViewController.swift
//  Karma
//
//  Created by Jared Gutierrez on 4/25/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class changeUsernameViewController: UIViewController {
    
    @IBOutlet weak var reenterUsername: UITextField!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var OldUsername: UITextField!
    
    
    
    
    
    func displayalert(title: String, displayError: String){
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    
    @IBAction func SubmitNewUsername(sender: AnyObject) {
        var displayerror = ""
        var currentUser = PFUser.currentUser()!
        var currentUsername = currentUser.username
        
        
        
        if OldUsername.text == "" || reenterUsername.text == "" || newUsername.text == "" {
            displayerror  = "Please Complete the form"
        } else if reenterUsername.text != newUsername.text {
            displayerror = "New Usernames Do Not Match"
        }
        else if currentUsername != OldUsername.text {
            displayerror = "Incorrect Username"
        }
        
        if displayerror != "" {
            displayalert("Error", displayError: displayerror)
        } else {
            print("Your Username Has Been Changed")
            currentUser.username = newUsername.text
            currentUser.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                    displayerror = "Could Not Update"
                    self.displayalert("Error", displayError: displayerror)
                }
            }
        }
        
    }

}
