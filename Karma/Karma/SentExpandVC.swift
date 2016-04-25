//
//  SentExpandVC.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/25/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse


class SentExpandVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collectionView: UICollectionView!
    var replies = Array<PFObject>()
    var message: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
                
        var query = PFQuery(className:"Replies")
        query.whereKey("messageId", equalTo: message!.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.replies.append(object)
                        print(object["replyBody"] as! String)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.collectionView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replies.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let sm = collectionView.dequeueReusableCellWithReuseIdentifier("originalSentMessage", forIndexPath: indexPath) as! OriginalSentMessageCollectionViewCell
            
            //np.layoutMargins
            sm.sentMessageText.text = message!["messageBody"] as! String
            sm.sentMessageDate.text = cleanTime(message!["sentDate"] as! NSDate)
            //placeholder
            return sm
            
        } else {
            let replyCell = collectionView.dequeueReusableCellWithReuseIdentifier("reply", forIndexPath: indexPath) as! ReplyCollectionViewCell
            
            //design cell
            replyCell.layer.borderColor = UIColor.whiteColor().CGColor
            replyCell.layer.borderWidth = 1
            replyCell.layer.shadowOffset = CGSizeMake(0, 1)
            replyCell.layer.shadowColor = UIColor(netHex:0xCDBA96).CGColor
            replyCell.layer.shadowRadius = 3
            replyCell.layer.cornerRadius = 3
            
            replyCell.layer.shadowOpacity = 0.7
            
            let shadowFrame: CGRect = (replyCell.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            replyCell.layer.shadowPath = shadowPath
            replyCell.clipsToBounds = false
            
            
            
            
            if replies.count > 0 {
                replyCell.replyBody.text = replies[indexPath.row]["replyBody"] as? String
                replyCell.replyDate.text = cleanTime(replies[indexPath.row]["replyDate"] as! NSDate)
//                sc.audience.text = locations[indexPath.item]
//                sc.timeStamp.text = cleanTime(sentTimes[indexPath.row])
            }
            return replyCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        //        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.sectionInset = UIEdgeInsetsMake(-10, 0, 0, 0);
        let frame : CGRect = self.view.frame
        return UIEdgeInsetsMake(10, -30, 0, -30) // margin between cells
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
