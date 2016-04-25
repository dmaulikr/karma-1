//
//  receivedViewController.swift
//  karma3
//
//  Created by Jared Gutierrez on 4/8/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import Parse

class receivedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    
//    var sendtextfield = UITextField(frame: CGRectMake(10, 5, UIScreen.mainScreen().bounds.width - 20, 95))
//    
//    var sendbutton = UIButton( frame: CGRectMake(300, 56 ,50, 40
//    ))
    var refresher:UIRefreshControl!
    var locations = Array<String>()
    var body = Array<String>()
    var currentIndex = -1;
    var timesArray = Array<NSDate>()
    var messageIds = Array<String>()
    var replied = Array<Bool>()
    var messages = Array<PFObject>()
    var currUser = PFUser.currentUser()!
    var userId = PFUser.currentUser()!.objectId
    var replyOpenText = false
    
    func getMessages() {
        // Get the list of all the social titles and add them to the socialLabels array. Then reload the collectionview.
        let query = PFQuery(className:"Messages")
        query.orderByDescending("sentDate")
        query.whereKey("recieverIds", equalTo: userId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) socials.")
                
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //self.times.append(object["socialTitle"] as! String)
                        self.locations.append ( object["audience"] as! String)
                        self.body.append(object["messageBody"] as! String)
                        self.messages.append(object)
                        self.messageIds.append(object.objectId!)
                        let repliedIds = object["repliedIds"] as! NSArray
                        self.replied.append(repliedIds.containsObject(self.userId!))
                        
                        self.timesArray.append((object["sentDate"] as? NSDate)!)
                    }
                    self.receivedMessagesCollectionView.reloadData()
                    self.refresher.endRefreshing()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func cleanTime(sentDate: NSDate) -> String {
        
        var timeInterval : NSTimeInterval = sentDate.timeIntervalSinceNow
        timeInterval = timeInterval * -1
        
        //print(timeInterval)
        if timeInterval < 60 {
            return "Just now"
        } else if timeInterval < (60 * 60) {
            let numMinutes = Int(floor(timeInterval / 60))
            return String(numMinutes) + " minutes ago"
        } else if timeInterval < (2*60*60) {
            return "1 hour ago"
        } else if timeInterval < (24*60*60) {
            let numHours = Int(floor(timeInterval / (60*60)))
            return String(numHours) + " hours ago"
        } else if timeInterval < (48 * 60 * 60) {
            return "1 day ago"
        } else if timeInterval < (7 * 24 * 60 * 60) {
            let numDays = Int(floor(timeInterval / (24*60*60)))
            return String(numDays) + " days ago"
        } else if timeInterval < (2 * 7 * 24 * 60 * 60) {
            return "1 week ago"
        } else if timeInterval < (30 * 24 * 60 * 60) {
            let numWeeks = Int(floor(timeInterval / (7*24*60*60)))
            return String(numWeeks) + " weeks ago"
        } else if timeInterval < (2 * 30 * 24 * 60 * 60) {
            return "1 month ago"
        } else if timeInterval < (365 * 24 * 60 * 60) {
            let numMonths = Int(floor(timeInterval / (30*24*60*60)))
            return String(numMonths) + " months ago"
        } else if timeInterval < (365 * 24 * 60 * 60) {
            return "1 year ago"
        }
        
        let numYears = Int(floor(timeInterval / (365*24*60*60)))
        return String(numYears) + " years ago"
        
    }
    
    func addTapped() {
        self.tabBarController?.selectedIndex = 1
    }
    func refresh() {
        locations.removeAll()
        body.removeAll()
        messages.removeAll()
        timesArray.removeAll()
        messageIds.removeAll()
        replied.removeAll()
        
        currentIndex = -1;
        getMessages()
        
    }

    
    @IBOutlet weak var receivedMessagesCollectionView: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        replyOpenText = false
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedMessagesCollectionView.dataSource = self
        receivedMessagesCollectionView.delegate = self
        receivedMessagesCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        //layout spacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        
        //navbar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Received Messages";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(currUser["audienceLim"]), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
        
        //load Messages
        getMessages()
        
        
        //collectionViewwidth
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        
        receivedMessagesCollectionView.frame.size.width = screenWidth
        
        
        //refresher
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:#selector(receivedViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        receivedMessagesCollectionView.addSubview(refresher)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        
        self.performSegueWithIdentifier("tomessage", sender: indexPath)
        
    }
        
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = receivedMessagesCollectionView.dequeueReusableCellWithReuseIdentifier("recCell", forIndexPath: indexPath) as!receivedMessageCollectionViewCell
        
        //cell.backgroundView = nil;
        
        
        //Fill Cell Data
        print("body" + String(body.count))
        print(indexPath.row)
        cell.message.text = body[indexPath.row]
        cell.time.text = cleanTime(timesArray[indexPath.row])
        cell.location.text = locations[indexPath.row]
        
        //cell.replyTextField.hidden = true
        
        //design cell
        cell.backgroundColor = UIColor.whiteColor();
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSizeMake(0, 1)
        cell.layer.shadowColor = UIColor(netHex:0xCDBA96).CGColor
        cell.layer.shadowRadius = 3
        cell.layer.cornerRadius = 3
        
        cell.layer.shadowOpacity = 0.7
        
        let shadowFrame: CGRect = (cell.layer.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        cell.layer.shadowPath = shadowPath
        cell.clipsToBounds = false
        
        
        //reply button
        cell.replyButton.titleLabel?.font = UIFont.fontAwesomeOfSize(10)
        cell.replyButton.setTitle("Reply", forState: .Normal)
        
        if replied[indexPath.row] {
            cell.replyButton.setTitle(String.fontAwesomeIconWithName(.Check), forState: .Normal)
        }
        
        
        
        
        
        return cell
    }
    

    @IBAction func replyButtonClicked(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? receivedMessageCollectionViewCell {
                    let indexPath = receivedMessagesCollectionView.indexPathForCell(cell)
                    replyOpenText = true
                    self.performSegueWithIdentifier("tomessage", sender: indexPath)
                    
                    /*currentIndex = indexPath!.row
                    print("worked")
                    receivedMessagesCollectionView.reloadData()*/
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, -30, 0, -30) // margin between cells
    }


    
        
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return body.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tomessage" {
            let vc = segue.destinationViewController as! expandViewController
            let row = (sender as! NSIndexPath).item
            let message = messages[row]
            vc.message = message
            
            vc.replyOpenText = replyOpenText
            print("repOpen: " + String(replyOpenText))
            
            
            
        }
        
        
        
        
    }
    
        
}


