//
//  ViewController.swift
//  NSURLSessionDemo
//
//  Created by qihaijun on 2/2/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var taskList: [DownloadTask]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh:", name: DownloadTaskNotification.Finish.rawValue, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        taskList = TaskManager.sharedManager.unfinishedTasks()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh(sender: NSNotification) {
        taskList = TaskManager.sharedManager.unfinishedTasks()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DownloadTaskCell
        
        cell.updateData(taskList![indexPath.row])
        
        return cell
    }
}

