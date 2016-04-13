//
//  NewPostCollectionViewCell.swift
//  Karma
//
//  Created by Jessica Ji on 4/6/16.
//  Copyright © 2016 MDB - Karma. All rights reserved.
//

import UIKit

class NewPostCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func setPlaceholder() {
        print("hi")
        textView.delegate = self
        textView.text = "What's on your mind?"
        textView.textColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {        
        if (textView.text == "") {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    //dismiss keyboard

}
