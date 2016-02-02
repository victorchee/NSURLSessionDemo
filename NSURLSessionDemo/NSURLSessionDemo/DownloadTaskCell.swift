//
//  DownloadTaskCell.swift
//  NSURLSessionDemo
//
//  Created by qihaijun on 2/2/16.
//  Copyright © 2016 VictorChee. All rights reserved.
//

import UIKit

class DownloadTaskCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var downloadTask: DownloadTask?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProgress:", name: DownloadTaskNotification.Progress.rawValue, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProgress:", name: DownloadTaskNotification.Progress.rawValue, object: nil)
    }
    
    func updateProgress(sender: NSNotification) {
        guard let info = sender.userInfo else {
            return
        }
        guard let taskIdentifier = info["taskIdentifier"]?.integerValue where taskIdentifier == downloadTask!.taskIdentifier else {
            return
        }
        guard let written = info["totalBytesWritten"]?.longLongValue, total = info["totalBytesExpectedToWrite"]?.longLongValue else {
            return
        }
        let formattedWrittenSize = NSByteCountFormatter.stringFromByteCount(written, countStyle: .File)
        let formattedTotalSize = NSByteCountFormatter.stringFromByteCount(total, countStyle: .File)
        sizeLabel.text = "\(formattedWrittenSize) / \(formattedTotalSize)"
        
        let percentage = Int(Double(written) / Double(total) * 100.0)
        progressLabel.text = "\(percentage)%"
    }
    
    func updateData(task: DownloadTask) {
        self.downloadTask = task
        nameLabel.text = task.url.lastPathComponent
    }
}
