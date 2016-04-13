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
    
    var locations = Array<String>()
    var body = Array<String>()
    var currentIndex = -1;
    var timesArray = ["Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time","Time"]
    
    func getMessages() {
        // Get the list of all the social titles and add them to the socialLabels array. Then reload the collectionview.
        let query = PFQuery(className:"Messages")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) socials.")
                
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(objects!.count), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))
                
                
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //self.times.append(object["socialTitle"] as! String)
                        self.locations.append ( object["audience"] as! String)
                        self.body.append(object["messageBody"] as! String)
                    }
                    self.receivedMessagesCollectionView.reloadData()
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

    
    @IBOutlet weak var receivedMessagesCollectionView: UICollectionView!
    
   
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
        
        getMessages()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        
        self.view.backgroundColor = UIColor.greenColor()
        receivedMessagesCollectionView.frame.size.width = screenWidth
        receivedMessagesCollectionView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        receivedMessagesCollectionView.backgroundView = nil;
        
        
        let newMessageImage = UIImage.fontAwesomeIconWithName(.PencilSquareO, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(receivedViewController.addTapped))



        

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
        cell.message.text = body[indexPath.row]
        cell.time.text = timesArray[indexPath.row]
        cell.location.text = locations[indexPath.row]
        
        cell.replyTextField.hidden = true
        cell.frame.size.height = collectionView.frame.height / 5
        cell.frame.origin.y = ((collectionView.frame.height / 5) + 10) * (CGFloat(indexPath.row))
        if currentIndex == indexPath.row{
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
        }
        
        let collectionViewWidth = receivedMessagesCollectionView.bounds.size.width
        cell.frame.size.width = collectionViewWidth
        cell.frame.origin.x = receivedMessagesCollectionView.frame.origin.x
        
        
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        
        
        cell.layer.shadowOffset = CGSizeMake(0, 3)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        
        cell.layer.shadowOpacity = 0.9
        
        cell.replyButton.titleLabel?.font = UIFont.fontAwesomeOfSize(20)
        cell.replyButton.setTitle(String.fontAwesomeIconWithName(.PlusSquareO), forState: .Normal)
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
                    currentIndex = indexPath!.row
                    print("worked")
                    receivedMessagesCollectionView.reloadData()
                }
            }
        }
    }
    


    
    
    
        
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tomessage" {
            let vc = segue.destinationViewController as! expandViewController
            let row = (sender as! NSIndexPath).item
            let sendbody = body[row]
            vc.transferedmessage = sendbody
            let senddate = timesArray[row]
            vc.transfereddate = senddate
            let sendloc = locations[row]
            vc.transferedlocation = sendloc
            
            
            
        }
        
        
        
        
    }
    
        
}


