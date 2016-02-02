//
//  AddTaskViewController.swift
//  NSURLSessionDemo
//
//  Created by qihaijun on 2/2/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction func addTask(sender: UIBarButtonItem) {
        guard let url = NSURL(string: textView.text) else {
            return
        }
        TaskManager.sharedManager.addTask(url)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
