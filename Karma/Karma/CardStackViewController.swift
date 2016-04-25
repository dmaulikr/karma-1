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
        let screenHeight = bounds.size.height
        let cardWidth = screenWidth * (6 / 7) - screenWidth / 7
        let card = UIView(frame: CGRect(x: screenWidth / 7, y: 130, width: cardWidth, height: 400))
        card.backgroundColor = UIColor.randomColor()
        card.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderWidth = 0.4
        card.layer.cornerRadius = 7.0
        var label = UILabel(frame: CGRectMake(screenWidth / 7 + 20, 130 + 20, 200, 800))
        
        //label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Left
        label.numberOfLines = 0
        label.text = messagesToShow[index]["messageBody"] as? String
        label.sizeToFit()
        
        card.addSubview(label)
        
        let message = messagesToShow[index]
        markAsRead(message)
        
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
