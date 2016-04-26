//
//  CardStackViewController.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/23/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class CardStackViewController: UIViewController, YSLDraggableCardContainerDataSource, YSLDraggableCardContainerDelegate {
    
    var container = YSLDraggableCardContainer()
    var messagesToShow = Array<PFObject>()
    var currentUser = PFUser.currentUser()
    
    @IBOutlet weak var exitButton: UIButton!
    @IBAction func exitButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        print("thingggyy")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        container = YSLDraggableCardContainer()
        container.frame = self.view.bounds
        container.backgroundColor = UIColor.clearColor()
        container.dataSource = self
        container.delegate = self
        
        self.view.addSubview(container)
        self.view.bringSubviewToFront(exitButton)
        
        container.reloadCardContainer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardContainerViewNextViewWithIndex(index: Int) -> UIView! {
        
        let bounds = UIScreen.mainScreen().bounds
        let screenWidth = bounds.size.width
        let cardWidth = screenWidth * (6 / 7) - screenWidth / 7
        let card = UIView(frame: CGRect(x: screenWidth / 7, y: 130, width: cardWidth, height: 400))
        card.backgroundColor = UIColor.randomColor()
        card.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderWidth = 0.4
        card.layer.cornerRadius = 7.0
        let label = UILabel(frame: CGRectMake(screenWidth / 7, 130, 200, 800))
        
        label.center = (CGPointMake(card.frame.size.width / 2, (card.frame.size.height / 2) + 400))
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.text = messagesToShow[index]["messageBody"] as? String
        label.font = UIFont.fontAwesomeOfSize(30)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        
        card.addSubview(label)
        

        
        let locLabel = UILabel(frame: CGRectMake(screenWidth / 7, 130, 200, 800))
        
        locLabel.center = (CGPointMake(card.frame.size.width / 2 + 25, (card.frame.size.height / 2) + 260))
        locLabel.textAlignment = NSTextAlignment.Center
        
        locLabel.numberOfLines = 0
        
        let imageName = "place"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: locLabel.frame.origin.x - 25, y: locLabel.frame.origin.y, width: 20, height: 20)
        
        card.addSubview(imageView)
        
        
        var longitude :CLLocationDegrees = (messagesToShow[index]["sentLocation"] as! PFGeoPoint).longitude
        var latitude :CLLocationDegrees = (messagesToShow[index]["sentLocation"] as! PFGeoPoint).latitude
        
        var location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                locLabel.text = pm.locality
                print(pm.locality)
                locLabel.textColor = UIColor(colorLiteralRed: 224/255.0, green: 224/255.0, blue: 235.0/255.0, alpha: 1.0)
                locLabel.font = UIFont.fontAwesomeOfSize(15)
                locLabel.sizeToFit()
                
                card.addSubview(locLabel)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        
        
        let timeLabel = UILabel(frame: CGRectMake(screenWidth / 7, 130, 200, 800))
        timeLabel.center = (CGPointMake(card.frame.size.width / 2, (card.frame.size.height / 2) + 285))
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.numberOfLines = 0
        timeLabel.text = "Sent: " + MDBSwiftUtils.timeSince((messagesToShow[index]["sentDate"] as? NSDate)!)
        timeLabel.textColor = UIColor(colorLiteralRed: 224/255.0, green: 224/255.0, blue: 235/255.0, alpha: 1.0)
        timeLabel.font = UIFont.fontAwesomeOfSize(15)
        timeLabel.sizeToFit()
        timeLabel.clipsToBounds = false
        
        card.addSubview(timeLabel)
        
        let message = messagesToShow[index]
        //markAsRead(message)
        
        return card
    }
    
    func markAsRead(message: PFObject) {
        message.addUniqueObject((currentUser?.objectId)!, forKey:"readIds")
        message.saveInBackground()
    }
    
    func cardContainerViewNumberOfViewInIndex(index: Int) -> Int {
        return messagesToShow.count
    }
    
    func cardContainerView(cardContainerView: YSLDraggableCardContainer!, didEndDraggingAtIndex index: Int, draggableView: UIView!, draggableDirection: YSLDraggableDirection) {
        
        cardContainerView.movePositionWithDirection(draggableDirection, isAutomatic: false)
        
        
    }
    
    func cardContainderView(cardContainderView: YSLDraggableCardContainer!, updatePositionWithDraggableView draggableView: UIView!, draggableDirection: YSLDraggableDirection, widthRatio: CGFloat, heightRatio: CGFloat) {
        //        var view = draggableView as! YSLCardView
        //        if draggableDirection == YSLDraggableDirection.Default {
        //            view.selectedView.alpha = 0
        //        }
        //        if draggableDirection == YSLDraggableDirection.Left {
        //
        //        }
        //
        //        if draggableDirection == YSLDraggableDirection.Right {
        //
        //        }
    }
    
    func cardContainerViewDidCompleteAll(container: YSLDraggableCardContainer!) {
        print("Did CompleteALL")
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func cardContainerView(cardContainerView: YSLDraggableCardContainer!, didSelectAtIndex index: Int, draggableView: UIView!) {
        print("Did select index: %d", index)
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
