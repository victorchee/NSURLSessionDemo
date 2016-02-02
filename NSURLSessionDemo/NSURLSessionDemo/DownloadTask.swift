//
//  DownloadTask.swift
//  NSURLSessionDemo
//
//  Created by qihaijun on 2/2/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import Foundation

struct DownloadTask {
    var url: NSURL
    var localURL: NSURL?
    var taskIdentifier: Int
    var finished = false
    
    init(url: NSURL, taskIdentifier: Int) {
        self.url = url
        self.taskIdentifier = taskIdentifier
    }
}

enum DownloadTaskNotification: String {
    case Progress = "DownloadNotificationProgress"
    case Finish = "DownloadNotificationFinish"
}