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
    var replies = Array<String>()
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
                        self.messageIds.append(object.objectId!)
                        var replyText = object["replyText"]
                        if replyText == nil {
                            self.replies.append("")
                        } else {
                            self.replies.append(object["replyText"] as! String)
                        }
                        
                        
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
        locations = Array<String>()
        body = Array<String>()
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Received Messages";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(currUser["audienceLim"]), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
        
        getMessages()
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        
        self.view.backgroundColor = UIColor.greenColor()
        receivedMessagesCollectionView.frame.size.width = screenWidth
        receivedMessagesCollectionView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        receivedMessagesCollectionView.backgroundView = nil;
        
        
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
        
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
        
        //modify the cell
        cell.backgroundColor = UIColor.whiteColor();
        //255, 184, 77
        cell.backgroundView = nil;
        print(body);
        cell.message.text = body[indexPath.row]
        cell.time.text = cleanTime(timesArray[indexPath.row])
        cell.location.text = locations[indexPath.row]
        
        cell.replyTextField.hidden = true
        cell.frame.size.height = collectionView.frame.height / 5
        cell.frame.origin.y = ((collectionView.frame.height / 5) + 10) * (CGFloat(indexPath.row))
        /*if currentIndex == indexPath.row{
            cell.frame.size.height = (collectionView.frame.height / 5) + 50
            
            
            cell.replyTextField.hidden = !cell.replyTextField.hidden
            
            /*var frameRect = cell.replyTextField.frame;
            frameRect.size.height = 50; // <-- Specify the height you want here.
            frameRect.size.width = cell.frame.size.width - 10.0;
            cell.replyTextField.bounds.origin.x = 5.0
            cell.replyTextField.bounds.origin.y = (cell.message.bounds.origin.y + cell.message.frame.height)
            cell.replyTextField.frame.origin.x = 5.0
            cell.replyTextField.frame.origin.y = (cell.message.bounds.origin.y + cell.message.frame.height)
            cell.replyTextField.layer.frame.origin.y = (cell.message.bounds.origin.y + cell.message.frame.height)
            var layerFrame = cell.replyTextField.layer.frame
            layerFrame.size.height = 50
            layerFrame.size.width = cell.frame.size.width - 10.0;
            
            cell.replyTextField.frame = frameRect
            cell.replyTextField.layer.frame = layerFrame*/
            var frame = cell.replyTextField.frame
            frame.size.height = 100.0;
            cell.replyTextField.frame = frame
            
            
            
            cell.replyTextField.placeholder = "How would you like to reply?"
            //cell.replyTextField.backgroundColor = UIColor.whiteColor()
            
            cell.replyTextField.borderStyle = UITextBorderStyle.Line
        } else if currentIndex < indexPath.row  && currentIndex != -1{
            cell.frame.origin.y = cell.frame.origin.y + 50
        }*/
        
        let collectionViewWidth = receivedMessagesCollectionView.bounds.size.width
        cell.frame.size.width = collectionViewWidth
        cell.frame.origin.x = receivedMessagesCollectionView.frame.origin.x
        
        
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        
        
        cell.layer.shadowOffset = CGSizeMake(0, 3)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        
        cell.layer.shadowOpacity = 0.9
        
        cell.replyButton.titleLabel?.font = UIFont.fontAwesomeOfSize(10)
        cell.replyButton.setTitle("Reply", forState: .Normal)
        
        if replies[indexPath.row] != "" {
            cell.replyButton.setTitle(String.fontAwesomeIconWithName(.Check), forState: .Normal)
        }
        
        //cell.replyButton.setTit
        cell.replyButton.layer.cornerRadius = 0.5 *  cell.replyButton.bounds.size.width
        cell.replyButton.clipsToBounds = true
        
        // Maybe just me, but I had to add it to work:
        cell.clipsToBounds = false
        
        let shadowFrame: CGRect = (cell.layer.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        cell.layer.shadowPath = shadowPath
        
        
        
        
        
        return cell
    }
    
    
    
//    @IBAction func replyButtonClicked(sender: AnyObject) {
//        if let button = sender as? UIButton {
//            if let superview = button.superview {
//                if let cell = superview.superview as? FeedCollectionViewCell {
//                    let indexPath = collectionView?.indexPathForCell(cell)
//                    currentIndex = indexPath!.row
//                    collectionView?.reloadData()
//                }
//            }
//        }
//    }

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
            let sendbody = body[row]
            vc.transferedmessage = sendbody
            let senddate = timesArray[row]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let dateString = dateFormatter.stringFromDate(senddate)
            vc.transfereddate = dateString
            let sendloc = locations[row]
            vc.transferedlocation = sendloc
            let id = messageIds[row]
            vc.messageId = id
            
            vc.replyOpenText = replyOpenText
            print("repOpen: " + String(replyOpenText))
            
            
            
        }
        
        
        
        
    }
    
        
}


