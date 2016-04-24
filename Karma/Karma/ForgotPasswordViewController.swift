//
//  ForgotPasswordViewController.swift
//  Karma
//
//  Created by Jared Gutierrez on 4/24/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {

    func displayalert(title: String, displayError: String){
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
//            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var SendResetLink: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            PFUser.requestPasswordResetForEmailInBackground(EmailTextField.text!)}
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
