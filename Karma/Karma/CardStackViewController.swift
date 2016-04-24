//
//  CardStackViewController.swift
//  Karma
//
//  Created by Ankur Mahesh on 4/23/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit

class CardStackViewController: UIViewController, YSLDraggableCardContainerDataSource, YSLDraggableCardContainerDelegate {
    
    var container = YSLDraggableCardContainer()
    let datas = NSArray()
    
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
        
        let card = UIView(frame: CGRect(x: 30, y: 80, width: 300, height: 400))
        card.backgroundColor = UIColor.randomColor()
        card.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderWidth = 0.4
        card.layer.cornerRadius = 7.0
        
        return card
    }
    
    func cardContainerViewNumberOfViewInIndex(index: Int) -> Int {
        return 10
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
