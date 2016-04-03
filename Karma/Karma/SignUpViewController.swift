//
//  SignUpViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var takenAlert: UILabel!
    @IBOutlet weak var emailAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takenAlert.hidden = true
        emailAlert.hidden = true
    }

    
    @IBAction func trySignUp(sender: AnyObject) {
        
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text
        user["firstName"] = firstName.text
        user["lastName"] = lastName.text
        user["audienceLim"] = 1
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            //query
            
            if (success) {
                self.performSegueWithIdentifier("toMain2", sender: self)
            } else {
                
                self.takenAlert.hidden = false
            }
        }
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

}
