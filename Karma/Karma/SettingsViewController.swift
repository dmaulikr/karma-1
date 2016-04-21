//
//  SettingsViewController.swift
//  karmaSettings
//
//  Created by Jared Gutierrez on 4/9/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, settingTableViewCellDelegate {

    @IBOutlet weak var settingstable: UITableView!
     var myAccountLabel = UILabel(frame: CGRectMake(20, 0 , 200, 60
        ))
    
    var usernameLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    var passwordLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    var notificationsLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    
    var notificationSwitch=UISwitch(frame:CGRectMake(300, 10, 100, 35
        ));
    
    
    var accountActionsLabel = UILabel(frame: CGRectMake(20, 0 , 200, 60
        ))
   
    var clearFeedLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    var logOutLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    
    
    
    let logOutAlertController = UIAlertController(title: "Log Out", message: "Would you like to log out of your account?", preferredStyle: .Alert)
    
    let cancelLogout = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    let confirmLogout = UIAlertAction(title: "Log Out", style: .Default) { (UIAlertAction) in
        PFUser.logOut()
        print("You are no longer signed in")
        
    }
    
    
    
    
    func clearFeed() {
        let query = PFQuery(className:"Messages")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) socials.")
            }
            if let objects = objects {
                for object in objects {
                    object.deleteInBackground()
                }
            }
        }
    }
    
    
    
    
    let clearFeedAlertController = UIAlertController(title: "Clear Feed", message: "Are you sure that you want to clear your feeds", preferredStyle: .Alert)
    
    let cancelClear = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    let confirmClear = UIAlertAction(title: "Clear", style: .Default) { (UIAlertAction) in
//        SettingsViewController.clearFeed()
        print("You have cleared your feed")
        
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Settings"
        //;
        
        

        
        clearFeedAlertController.addAction(cancelClear)
        clearFeedAlertController.addAction(confirmClear)
        
        logOutAlertController.addAction(cancelLogout)
        logOutAlertController.addAction(confirmLogout)
        
        
        settingstable.delegate = self
        settingstable.dataSource = self
        
        notificationSwitch.on = true
        notificationSwitch.setOn(true, animated: false)
//        notificationSwitch.addTarget(self, action: "turnOffNotifications", forControlEvents: .ValueChanged)
        
        notificationSwitch.onTintColor = UIColor.init(colorLiteralRed: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        
        
        notificationsLabel.text = "Notifications Off"
        notificationsLabel.font =  UIFont(name: "Avenir Next", size: 18)
        notificationsLabel.backgroundColor = UIColor.clearColor()
        
        usernameLabel.text = "Change Username"
        usernameLabel.font =  UIFont(name: "Avenir Next", size: 18)
        usernameLabel.backgroundColor = UIColor.clearColor()
        
        passwordLabel.text = "Change Password"
        passwordLabel.font =  UIFont(name: "Avenir Next", size: 18)
        passwordLabel.backgroundColor = UIColor.clearColor()
        
        clearFeedLabel.text = "Clear Feed"
        clearFeedLabel.font =  UIFont(name: "Avenir Next", size: 18)
        clearFeedLabel.backgroundColor = UIColor.clearColor()
        
        logOutLabel.text = "Log Out"
        logOutLabel.font =  UIFont(name: "Avenir Next", size: 18)
        logOutLabel.backgroundColor = UIColor.clearColor()
        
        
        
        
        
        
        
        
        
        
        myAccountLabel.text = "My Account"
        myAccountLabel.textColor = UIColor(colorLiteralRed: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        myAccountLabel.font =  UIFont(name: "Avenir Next", size: 20)
        
        
        accountActionsLabel.text = "Account Actions"
        accountActionsLabel.textColor = UIColor(colorLiteralRed: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        accountActionsLabel
            .font =  UIFont(name: "Avenir Next", size: 20)
        
       
        
        
     

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: indexPath)
//    }
    
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! settingTableViewCell
        if indexPath.row == 0{
            cell.backgroundColor = UIColor.init(colorLiteralRed: 0.898, green: 0.894, blue: 0.886, alpha: 1)
            
            cell.addSubview(myAccountLabel)
        }
        if indexPath.row == 1{
            cell.addSubview(usernameLabel)
        }
        if indexPath.row == 2 {
            cell.addSubview(passwordLabel)
        }
        if indexPath.row == 3{
            cell.addSubview(notificationsLabel)
            cell.addSubview(notificationSwitch)
        }
        if indexPath.row == 5
        {
            cell.backgroundColor = UIColor.init(colorLiteralRed: 0.898, green: 0.894, blue: 0.886, alpha: 1)
            cell.addSubview(accountActionsLabel)
        }
        
        if indexPath.row == 6{
            cell.addSubview(clearFeedLabel)
        }
        
        if indexPath.row == 7{
            cell.addSubview(logOutLabel)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }
        if indexPath.row == 5{
            return 60
        }
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let row = (sender as! NSIndexPath).item
        if segue.identifier == "toChangePassword"{
            let vc = segue.destinationViewController as! changePasswordViewController
        }
    }
 
    
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            self.performSegueWithIdentifier("toChangePassword", sender: indexPath)            
        }
        else if indexPath.row == 7 {
            self.presentViewController(logOutAlertController, animated: true, completion: nil
            )
        }
        else if indexPath.row == 6 {
            self.presentViewController(clearFeedAlertController, animated: true, completion: nil)
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
