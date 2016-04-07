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
    var sentArray = []
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return sentArray.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // customize border between sections width between sections
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let newPostCell = collectionView.dequeueReusableCellWithReuseIdentifier("newPost", forIndexPath: indexPath) as! SentCollectionViewCell
                
            return newPostCell
        } else {
            let sentCell = collectionView.dequeueReusableCellWithReuseIdentifier("sentMessage", forIndexPath: indexPath) as! SentCollectionViewCell
            
            
            return sentCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("sentToDetail", sender: indexPath)
    }
    
    //add //design elements on cards
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sentToDetail" {
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
        
    }
    
    func queryMessages() {
        // query for messages sent by user
        let query = PFQuery(className:"Messages")
        query.whereKey("senderId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) ->Void in
            if error == nil {
                print("Successfully retrieved sent")
                self.sentArray = objects!
                self.collectionView!.reloadData()
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        print(self.sentArray.count)
    }
    
    func setProperties() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
        //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Sent Messages";
        
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeedCollectionViewController.addTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
