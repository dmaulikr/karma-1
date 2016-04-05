//
//  FeedCollectionViewController.swift
//  karma2
//
//  Created by Jared Gutierrez on 4/2/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"

class FeedCollectionViewController: UICollectionViewController {
    
    
    
    
    var times = ["Today","Last week","March 2", "March 32", "July 3", "August 3","Today","Last week","March 2", "March 32", "July 3", "August 3"]
    var locations = Array<String>()
    var body = Array<String>()
    var currentIndex = -1;
    
    func getMessages() {
        // Get the list of all the social titles and add them to the socialLabels array. Then reload the collectionview.
        let query = PFQuery(className:"Messages")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) socials.")
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(objects!.count), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeedCollectionViewController.addTapped))
                
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //self.times.append(object["socialTitle"] as! String)
                        self.locations.append ( object["audience"] as! String)
                        self.body.append(object["messageBody"] as! String)
                    }
                    self.collectionView!.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func addTapped() {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.translucent = false;
            //UIColor(red: 0.965, green: 0.698, blue: 0.42, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.topItem!.title = "Received Messages";
        
        getMessages()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        
        self.collectionView!.frame.size.width = screenWidth
        
        
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeedCollectionViewController.addTapped))
        
        
        
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

    @IBAction func replyButtonClicked(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? FeedCollectionViewCell {
                    let indexPath = collectionView?.indexPathForCell(cell)
                    currentIndex = indexPath!.row
                    collectionView?.reloadData()
                }
            }
        }
    }
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
        
        cell.replyTextField.hidden = true
        cell.frame.size.height = collectionView.frame.height / 5
        cell.frame.origin.y = ((collectionView.frame.height / 5) + 10) * (CGFloat(indexPath.row))
        if currentIndex == indexPath.row{
            cell.frame.size.height = (collectionView.frame.height / 5) + 50
            cell.replyTextField.hidden = false
        } else if currentIndex < indexPath.row  && currentIndex != -1{
            cell.frame.origin.y = cell.frame.origin.y + 50
        }
        
        let collectionViewWidth = self.collectionView!.bounds.size.width
        cell.frame.size.width = collectionViewWidth
        cell.frame.origin.x = self.collectionView!.frame.origin.x
        
        
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        
        
        cell.layer.shadowOffset = CGSizeMake(0, 3)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        
        cell.layer.shadowOpacity = 0.6
        
        cell.replyButton.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.replyButton.setTitle(String.fontAwesomeIconWithName(.PlusSquareO), forState: .Normal)
        cell.replyButton.layer.cornerRadius = 0.5 *  cell.replyButton.bounds.size.width
        cell.replyButton.clipsToBounds = true
        
        // Maybe just me, but I had to add it to work:
        cell.clipsToBounds = false
        
        let shadowFrame: CGRect = (cell.layer.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        cell.layer.shadowPath = shadowPath
        
        
        
        cell.replyTextField.frame.origin.x = 5.0
        cell.replyTextField.frame.origin.y = (cell.message.bounds.origin.y + cell.message.frame.height)
        cell.replyTextField.frame.size.width = cell.frame.size.width - 10.0
        cell.replyTextField.frame.size.height = 50.0
        cell.replyTextField.placeholder = "How would you like to reply?"
        cell.replyTextField.backgroundColor = UIColor.whiteColor()
        cell.replyTextField.borderStyle = UITextBorderStyle.Line
        
        
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
