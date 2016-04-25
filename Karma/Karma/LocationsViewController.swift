//
//  LocationsViewController.swift
//  Karma
//
//  Created by Jessica Ji on 4/24/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit
import Parse

class LocationsViewController: UITableViewController {
    
    var locationOptions = ["Local (20 miles)", "Mid-Scale (200 miles)", "Expansive (2000 miles)"]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath);
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        let cellWidth = cell.bounds.size.width
        let cellHeight = cell.bounds.size.height
        label.center = CGPointMake(cellWidth / 2, cellHeight / 2)
        label.textAlignment = NSTextAlignment.Center
        label.text = locationOptions[indexPath.row]
        cell.addSubview(label)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var radius = 0.1
        if (indexPath.row == 0) {
            radius = 20.0
        } else if (indexPath.row == 1) {
            radius = 200.0
        } else if (indexPath.row == 2) {
            radius = 2000.0
        }
        DataStorage.storeDouble("radius", myDouble: radius)
//        DataStorage.storeBoolean("userHasPutInRadius", boolToStore: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
