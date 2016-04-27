//
//  ForgotPasswordViewController.swift
//  Karma
//
//  Created by Jared Gutierrez on 4/24/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    func displayalert(title: String, displayError: String){
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
//            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    @IBAction func backToLoginPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var SendResetLink: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SendResetButton(sender: AnyObject) {
        
        if EmailTextField.text == "" {
            var emailerror = "Please Enter an Email"
            displayalert("Error", displayError: emailerror)
        }
        else {
            print(EmailTextField.text!)
            resetPassword(EmailTextField.text!)
                   }
    }
        
        func resetPassword(email : String){
            
            // convert the email string to lower case
            let emailToLowerCase = email.lowercaseString
            // remove any whitespaces before and after the email address
            let emailClean = emailToLowerCase.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            print(emailClean)
            
            PFUser.requestPasswordResetForEmailInBackground(emailClean) { (success, error) -> Void in
                if (error == nil) {
                    let success = UIAlertController(title: "Success", message: "Success! Check your email!", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    success.addAction(okButton)
                    self.presentViewController(success, animated: false, completion: nil)
                    
                }else {
                    let errormessage = error!.userInfo["error"] as! NSString
                    let error = UIAlertController(title: "Cannot complete request", message: errormessage as String, preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    error.addAction(okButton)
                    self.presentViewController(error, animated: false, completion: nil)
                }
            }
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    */

}
