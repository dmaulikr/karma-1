//
//  SentViewController.swift
//  Karma
//
//  Created by Shaan Appel on 4/2/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class SentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var locations = Array<String>()
    var messages = Array<String>()
    
    
    @IBOutlet weak var messageBody: UILabel!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return locations.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // customize border between sections width between sections
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let np = collectionView.dequeueReusableCellWithReuseIdentifier("newPost", forIndexPath: indexPath) as! NewPostCollectionViewCell
            
            //design cell
            np.layer.borderColor = UIColor.whiteColor().CGColor
            np.layer.borderWidth = 1
            
            np.layer.shadowOffset = CGSizeMake(0, 3)
            np.layer.shadowColor = UIColor.blackColor().CGColor
            
            np.layer.shadowOpacity = 0.9
            
            
            let shadowFrame: CGRect = (np.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            np.layer.shadowPath = shadowPath
            np.clipsToBounds = false

            
            //placeholder
            np.setPlaceholder()
            
            return np

            
        } else {
            let sc = collectionView.dequeueReusableCellWithReuseIdentifier("sentMessage", forIndexPath: indexPath) as! SentCollectionViewCell
            
            //design cell
            sc.backgroundColor = UIColor.whiteColor();
            sc.layer.borderColor = UIColor.whiteColor().CGColor
            sc.layer.borderWidth = 1
            sc.layer.shadowOffset = CGSizeMake(0, 3)
            sc.layer.shadowColor = UIColor.blackColor().CGColor
            
            sc.layer.shadowOpacity = 0.9
            
            let shadowFrame: CGRect = (np.layer.bounds)
            let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
            np.layer.shadowPath = shadowPath
            np.clipsToBounds = false

            
            
            if messages.count > 0 {
                sc.messageBody.text = messages[indexPath.item]
            }
            return sc
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("expandSent", sender: indexPath)
    }
    
    //add //design elements on cards
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "expandSent" {
            let vc = segue.destinationViewController as! expandViewController
            let row = (sender as! NSIndexPath).item
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    
        queryMessages()
        setProperties()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func queryMessages() {
        // query for messages sent by user
        let query = PFQuery(className:"Messages")
        query.whereKey("senderId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) ->Void in
            if error == nil {
                print("Successfully retrieved sent")
                
                if let objects = objects {
                    for object in objects {
                        self.locations.append ( object["audience"] as! String)
                        self.messages.append(object["messageBody"] as! String)
                    }
                }
                
                
                self.collectionView!.reloadData()
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        print(self.messages.count)
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
    

    

}
