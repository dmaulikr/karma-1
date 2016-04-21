//
//  changePasswordViewController.swift
//  karmaSettings
//
//  Created by Jared Gutierrez on 4/12/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import Parse

class changePasswordViewController: UIViewController {
    
    @IBOutlet weak var reenterNewPassword: UITextField!
    @IBOutlet weak var enterNewPassword: UITextField!
    @IBOutlet weak var enterOldPassword: UITextField!
    
    
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
    
    
    @IBAction func SubmitNewPassword(sender: AnyObject) {
        var displayerror = ""
        var currentUser = PFUser.currentUser()!
        
        
        
        
        if reenterNewPassword.text == "" || enterNewPassword.text == "" || enterOldPassword.text == "" {
            displayerror  = "Please Complete the form"
        } else if reenterNewPassword.text != enterNewPassword.text {
            displayerror = "New Passwords Do Not Match"
        }
//        else if currentUser["password"].text != enterOldPassword.text {
//            displayerror = "Incorrect Password"
//        }
        
        if displayerror != "" {
            displayalert("Error", displayError: displayerror)
        } else {
            print("Your Password Has Been Changed")
            currentUser["password"] = enterNewPassword.text
            currentUser.saveInBackground()
            
        }

    }

}
