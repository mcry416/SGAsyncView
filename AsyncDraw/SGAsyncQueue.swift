//
//  SGAsyncQueue.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/25.
//

import Foundation

final class SGAsyncQueue {
    
    public var queue: DispatchQueue = { dispatch_queue_serial_t(label: "com.sg.async_draw.queue", qos: .userInitiated) }()
    
    public var taskCount: Int = 0
    
    public var index: Int = 0
}
