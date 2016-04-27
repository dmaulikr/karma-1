//
//  SentViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class SentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewPostCollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var locations = Array<String>()
    var messages = Array<String>()
    var seenCount = Array<Int>()
    var sentTimes = Array<NSDate>()
    var msgObjects = Array<PFObject>()
    var refresher:UIRefreshControl!
    var index = Int()
    var replyCount = Array<Int>()
    var popoverController:UIPopoverPresentationController? = nil
    var replies = Array<PFObject>()
    
    
    @IBOutlet weak var messageBody: UILabel!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return messages.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGFloat()
        if (indexPath.section == 0) {
            size = 145
        } else {
            let labelWidth = UIScreen.mainScreen().bounds.width - 40
            let labelHeight = MDBSwiftUtils.getMultiLineLabelHeight(messages[indexPath.item], maxWidth: Int(labelWidth), font: UIFont.systemFontOfSize(14))
            
            size = 100 + labelHeight - 46 + 20
        }
        return CGSizeMake(UIScreen.mainScreen().bounds.width - 20, size)
        
    }
    
    
    
    
    // customize border between sections width between sections
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let np = collectionView.dequeueReusableCellWithReuseIdentifier("newPost", forIndexPath: indexPath) as! NewPostCollectionViewCell
            
            np.delegate = self
            var currUserAudLim = PFUser.currentUser()!["audienceLim"] as! Int
            var audLimString = ""
            if currUserAudLim == 1 {
                audLimString = "1 PERSON)"
            } else {
                audLimString = String(currUserAudLim) + " PEOPLE)"
            }
            var buttonTitle = "SEND (" + audLimString
//                String(format: "SEND(%i", audLimString)
            
            np.sendButton.setTitle(buttonTitle, forState: .Normal)
            np.sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            //np.layoutMargins
            
            
            //placeholder
            np.setPlaceholder()
            
            return np
            
            
        } else {
            let sc = collectionView.dequeueReusableCellWithReuseIdentifier("sentMessage", forIndexPath: indexPath) as! SentCollectionViewCell
            
            //design cell
            sc.backgroundColor = UIColor.whiteColor();
            sc.layer.borderColor = UIColor.whiteColor().CGColor
            sc.layer.borderWidth = 1
            sc.layer.shadowOffset = CGSizeMake(0, 1)
            sc.layer.shadowColor = UIColor(netHex:0xCDBA96).CGColor
            sc.layer.shadowRadius = 3
            sc.layer.cornerRadius = 3
            
            sc.layer.shadowOpacity = 0.7
            
            let shadowFrame: CGRect = (sc.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            sc.layer.shadowPath = shadowPath
            sc.clipsToBounds = false
            
            
            
            
            if messages.count > 0 {
                sc.messageBody.text = messages[indexPath.item]
                sc.seenBy.text = "Seen by " + String(seenCount[indexPath.item])
                sc.audience.text = locations[indexPath.item]
                sc.timeStamp.text = cleanTime(sentTimes[indexPath.row])
                if (replyCount[indexPath.item] == 1) {
                    sc.numReplies.text = "1 reply"
                } else {
                    sc.numReplies.text = String(replyCount[indexPath.item]) + " replies"
                }
            }
            return sc
        }
    }
    
    func selectLocationsPressed(cell: NewPostCollectionViewCell) {
        //Select locations was called, show popover
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("locationSelection") as! LocationsViewController
        //        var nav = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        //        popoverController =
        vc.preferredContentSize = CGSizeMake(320,300)
        vc.popoverPresentationController!.delegate = self
        vc.popoverPresentationController!.sourceView = cell
        vc.popoverPresentationController!.sourceRect = cell.setAudience.frame
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
    }
    
    func parentShouldShowAlert(string: String, title: String) {
        //String is the text of the alert
        self.displayAlert(title, displayError: string)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        index = indexPath.row
        if (indexPath.section != 0) {
            self.performSegueWithIdentifier("toSentExpand", sender: indexPath)
        }
    }
    
    //    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        index = indexPath.item
    //        return true
    //    }
    
    //add //design elements on cards
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSentExpand" {
            print("preparing")
            let vc = segue.destinationViewController as! SentExpandVC
            print("msgObjects")
            print(msgObjects.count)
            print("index")
            print(index)
            vc.message = msgObjects[index]
            //            var query = PFQuery(className:"Replies")
            //            query.whereKey("messageId", equalTo: msgObjects[index].objectId!)
            //            query.findObjectsInBackgroundWithBlock {
            //                (objects: [PFObject]?, error: NSError?) -> Void in
            //
            //                if error == nil {
            //                    // The find succeeded.
            //                    // Do something with the found objects
            //                    if let objects = objects {
            //                        self.replies = objects
            //                    }
            //                } else {
            //                    // Log details of the failure
            //                    print("Error: \(error!) \(error!.userInfo)")
            //                }
            //            }
            vc.replies = replies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        queryMessages()
        setProperties()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:#selector(SentViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refresher)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        //        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.sectionInset = UIEdgeInsetsMake(-10, 0, 0, 0);
        let frame : CGRect = self.view.frame
        return UIEdgeInsetsMake(10, -30, 0, -30) // margin between cells
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func queryMessages() {
        // query for messages sent by user
        let query = PFQuery(className:"Messages")
        query.whereKey("authorized", equalTo: true)
        query.whereKey("flagged", notEqualTo: true)
        query.orderByDescending("sentDate")
        query.whereKey("senderId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) ->Void in
            if error == nil {
                print("Successfully retrieved sent")
                
                if let objects = objects {
                    for object in objects {
                        self.msgObjects.append(object)
                        self.locations.append (object["sentScale"] as! String)
                        
                        
                        if object["repliedIds"] == nil {
                            self.replyCount.append(0)
                        } else {
                            self.replyCount.append(object["repliedIds"].count)
                        }
                        self.messages.append(String(object["messageBody"]))
                        self.sentTimes.append(object["sentDate"] as! NSDate)
                        if object["readIds"] == nil {
                            self.seenCount.append(0)
                        } else {
                            self.seenCount.append(object["readIds"].count)
                        }
                    }
                }
                self.collectionView!.reloadData()
                self.refresher.endRefreshing()
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        print(self.messages.count)
    }
    
    func refresh() {
        locations = Array<String>()
        messages = Array<String>()
        seenCount = Array<Int>()
        queryMessages()
        
    }
    
    func setProperties() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Sent Messages";
        
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
