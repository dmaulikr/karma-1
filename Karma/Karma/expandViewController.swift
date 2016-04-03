//
//  expandViewController.swift
//  karma2
//
//  Created by Jared Gutierrez on 4/2/16.
//  Copyright © 2016 Jared Gutierrez. All rights reserved.
//

import UIKit
import MapKit

class expandViewController: UIViewController {
    @IBOutlet weak var response: UITextField!
    @IBOutlet weak var receivedmessage: UILabel!

    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var transferedmessage = ""
    var transfereddate = ""
    var transferedlocation = ""
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.text = transferedlocation
        date.text = transfereddate
        receivedmessage.text = transferedmessage
      

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendReply(sender: AnyObject) {
    }
    
    @IBAction func sendThanks(sender: AnyObject) {
    }
    @IBOutlet weak var mapFrom: MKMapView!

}
