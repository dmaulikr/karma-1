//
//  SignUpViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var takenAlert: UILabel!
    @IBOutlet weak var emailAlert: UILabel!
    @IBOutlet weak var sameEmail: UILabel!
    
    var duplicateUsers = []
    var duplicateEmails = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        takenAlert.hidden = true
        emailAlert.hidden = true
        sameEmail.hidden = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5) {
            self.view.frame = CGRectOffset(self.view.frame, 0, -UIScreen.mainScreen().bounds.height/3 + 30)
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5) {
            self.view.frame = CGRectOffset(self.view.frame, 0, UIScreen.mainScreen().bounds.height/3 - 30)
            
        }
    }
    
    func displayEmptyFieldError() {
        let alert = UIAlertController(title: "halp", message: "Please fill in all fields", preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
        })
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func displayAlertAccept(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func trySignUp(sender: AnyObject) {
        self.sameEmail.hidden = true
        self.emailAlert.hidden = true
        self.takenAlert.hidden = true
        
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text
        user["firstName"] = firstName.text
        
        user["lastName"] = lastName.text
        user["audienceLim"] = 1
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: self.username.text!)
        do {
            self.duplicateUsers = try query.findObjects()
        } catch {
            print("Weird error")
        }
        
        query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: self.email.text!)
        do {
            self.duplicateEmails = try query.findObjects()
        } catch {
            print("Weird error #2")
        }
        
        print(self.duplicateUsers.count)
        print(self.duplicateEmails.count)

        
        if self.duplicateUsers.count > 0 {
            self.takenAlert.hidden = false
            self.duplicateUsers = []
        } else if self.duplicateEmails.count > 0 {
            self.sameEmail.hidden = false
            self.duplicateEmails = []
        } else {
            user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if (self.username.text == "" || self.password.text == "" || self.email.text == "" || self.lastName.text == "" || self.firstName.text == "") {
                
                self.displayEmptyFieldError()
                
            } else {
                    if (success) {
                        let termsMessage = "Please make sure that you do not send any content that could be offensive to others and that you conduct youself on this app in a friendly manner. Sincerely does not tolerate any form of bullying or offensive content. If you violate these rules, you may be permanently banned from this community."
                        self.displayAlertAccept("Terms & Conditions", content: termsMessage)
                    } else {
                        print("email error?")
                        self.emailAlert.hidden = false
                    }
                }
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
