//
//  TaskManager.swift
//  NSURLSessionDemo
//
//  Created by qihaijun on 2/2/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import Foundation

class TaskManager: NSObject {
    static let sharedManager = TaskManager()
    
    private var session: NSURLSession?
    var taskList = [DownloadTask]()
    
    override init() {
        super.init()
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.victorchee.backgroundSession")
        self.session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
    }
    
    func addTask(url: NSURL) {
        guard let downloadTask = self.session?.downloadTaskWithURL(url) else {
            return
        }
        downloadTask.resume()
        
        let task = DownloadTask(url: url, taskIdentifier: downloadTask.taskIdentifier)
        self.taskList.append(task)
    }
    
    func unfinishedTasks() -> [DownloadTask] {
        return taskList.filter({ (task) -> Bool in
            return task.finished == false
        })
    }
    
    func finishedTasks() -> [DownloadTask] {
        return taskList.filter { task in
            return task.finished
        }
    }
    
    func saveTaskList() {
        var json = [[String: AnyObject]]()
        
        for task in taskList {
            var item = [String: AnyObject]()
            item["url"] = task.url
            item["taskIdentifier"] = NSNumber(integer: task.taskIdentifier)
            item["finished"] = NSNumber(bool: task.finished)
            json.append(item)
        }
        
        guard !json.isEmpty else {
            return
        }
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: [])
            NSUserDefaults.standardUserDefaults().setObject(jsonData, forKey: "TaskList")
            NSUserDefaults.standardUserDefaults().synchronize()
        } catch {
            
        }
    }
    
    func loadTaskList() {
        guard let jsonData = NSUserDefaults.standardUserDefaults().objectForKey("TaskList") as? NSData else {
            return
        }
        do {
            guard let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [[String: AnyObject]] else {
                return
            }
            for item in json {
                guard let url = item["url"] as? NSURL else { return }
                guard let taskIdentifier = item["taskIdentifier"]?.integerValue else { return }
                guard let finished = item["finished"]?.boolValue else { return }
                
                var downloadTask = DownloadTask(url: url, taskIdentifier: taskIdentifier)
                downloadTask.finished = finished
                self.taskList.append(downloadTask)
            }
        } catch {
            
        }
    }
}

extension TaskManager: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        var fileName = String()
        
        for var task in taskList {
            if task.taskIdentifier == downloadTask.taskIdentifier {
                task.finished = true
                fileName = task.url.lastPathComponent ?? "temp"
                break
            }
        }
        
        if let documentURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
            let fileURL = documentURL.URLByAppendingPathComponent(fileName)
            do {
                try NSFileManager.defaultManager().moveItemAtURL(location, toURL: fileURL)
            } catch {
                
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(DownloadTaskNotification.Finish.rawValue, object: downloadTask, userInfo: ["taskIdentifier":downloadTask.taskIdentifier])
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progressInfo = ["taskIdentifier": downloadTask.taskIdentifier,
        "totalBytesWritten": NSNumber(longLong: totalBytesWritten),
        "totalBytesExpectedToWrite": NSNumber(longLong: totalBytesExpectedToWrite)]
        
        NSNotificationCenter.defaultCenter().postNotificationName(DownloadTaskNotification.Progress.rawValue, object: downloadTask, userInfo: progressInfo)
    }
}
