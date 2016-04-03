//
//  FeedCollectionViewController.swift
//  karma2
//
//  Created by Jared Gutierrez on 4/2/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FeedCollectionViewController: UICollectionViewController {
    
    
    
    
    var times = ["June 30","Last week","Today", "March 32", "July 3", "August 3"]
    var locations = ["berkeley, CA", "berkeley, CA","berkeley, CA","berkeley, CA","berkeley, CA", "A land far far away"]
    var body = ["Hey everyone at Berkeley! I hope you are all doing well. Don't stress out too much on midterms/finals. ", "merry christmas and happy holidays. Everyone enjoy your break","I hope you are doing well today.","Idealistic as it may sound, altruism should be the driving force in business, not just competition and a desire for wealth","have a cookie, take a nap", "good afternoon"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        self.navigationController!.navigationBar.topItem!.title = "Received Messages";
        self.tabBarController?.tabBar.barTintColor = UIColor.orangeColor()
//        self.edgesForExtendedLayout = UIRectEdgeNone
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(FeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return locations.count
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FeedCollectionViewCell
    
        // Configure the cell
        cell.message.text = body[indexPath.row]
        cell.Time.text = times[indexPath.row]
        cell.location.text = locations[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("tomessage", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tomessage" {
            let vc = segue.destinationViewController as! expandViewController
            let row = (sender as! NSIndexPath).item
            let sendbody = body[row]
            vc.transferedmessage = sendbody
            let senddate = times[row]
            vc.transfereddate = senddate
            let sendloc = locations[row]
            vc.transferedlocation = sendloc
            
            
            
        }
      
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
