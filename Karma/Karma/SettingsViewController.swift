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
    
    var ParseUsernameLabel = UILabel (frame: CGRectMake(270, 0, 200, 50))

    
    var changeUsernameLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    
    var accountActionsLabel = UILabel(frame: CGRectMake(20, 0 , 200, 60
        ))
   
    var clearFeedLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    var logOutLabel = UILabel (frame: CGRectMake(30, 0 , 200, 50))
    
    
    
    let logOutAlertController = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .Alert)
    
    let cancelLogout = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    let confirmLogout = UIAlertAction(title: "Log out", style: .Default) { (UIAlertAction) in
        PFUser.logOut()
        print("You are no longer signed in")
        
    }
    
    
    
    var currentUser = PFUser.currentUser()

    
    
    override func viewDidAppear(animated: Bool) {
        currentUser = PFUser.currentUser()
        ParseUsernameLabel.text = currentUser!["username"] as! String
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = PFUser.currentUser()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Settings"
        //;
        
        settingstable.tableFooterView = UIView()

        
        ParseUsernameLabel.text = currentUser!["username"] as! String
        ParseUsernameLabel.font =  UIFont(name: "Avenir Next", size: 18)
        ParseUsernameLabel.textColor = UIColor(colorLiteralRed: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        ParseUsernameLabel.backgroundColor = UIColor.clearColor()
        
        logOutAlertController.addAction(cancelLogout)
        logOutAlertController.addAction(confirmLogout)
        
        
        settingstable.delegate = self
        settingstable.dataSource = self
        
        changeUsernameLabel.text = "Change Username"
        changeUsernameLabel.font =  UIFont(name: "Avenir Next", size: 18)
        changeUsernameLabel.backgroundColor = UIColor.clearColor()
        
        
        

        
        usernameLabel.text = "Username"
        usernameLabel.font =  UIFont(name: "Avenir Next", size: 18)
        usernameLabel.backgroundColor = UIColor.clearColor()
        
        passwordLabel.text = "Change Password"
        passwordLabel.font =  UIFont(name: "Avenir Next", size: 18)
        passwordLabel.backgroundColor = UIColor.clearColor()
        
   
        
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
        return 8
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
            cell.addSubview(ParseUsernameLabel)
            cell.addSubview(usernameLabel)
        }
        if indexPath.row == 2 {
            cell.addSubview(passwordLabel)
        }
        if indexPath.row == 3 {
            cell.addSubview(changeUsernameLabel)
        }
        
        if indexPath.row == 4
        {
            cell.backgroundColor = UIColor.init(colorLiteralRed: 0.898, green: 0.894, blue: 0.886, alpha: 1)
            cell.addSubview(accountActionsLabel)
        }
        

        if indexPath.row == 5 {
            cell.addSubview(logOutLabel)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }
        if indexPath.row == 4{
            return 60
        }
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let row = (sender as! NSIndexPath).item
        if segue.identifier == "toChangePassword"{
            let vc = segue.destinationViewController as! ForgotPasswordViewController
        }
        if segue.identifier == "toChangeUsername" {
            let vc = segue.destinationViewController as! changeUsernameViewController

        }
    }
 
    
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            self.performSegueWithIdentifier("toChangePassword", sender: indexPath)            
        }
        if indexPath.row == 3 {
            self.performSegueWithIdentifier("toChangeUsername", sender: indexPath)
            
        }
            
            
        else if indexPath.row == 5 {
            let confirmLogOff = UIAlertAction(title: "Logout", style: .Default, handler: { (action) -> Void in
                // Logout
                PFUser.logOut()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView") as! UIViewController
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            })
            
            
            
            let logOutAlertController = UIAlertController(title: "Log Out", message: "Would you like to log out of your account?", preferredStyle: .Alert)
            let cancelLogout = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            logOutAlertController.addAction(cancelLogout)
            logOutAlertController.addAction(confirmLogOff)
            
            self.presentViewController(logOutAlertController, animated: true, completion: nil)

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
