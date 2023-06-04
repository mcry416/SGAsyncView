//
//  SGAsyncQueuePool.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/25.
//

import Foundation

final class SGAsyncQueuePool {
    
    public static let singleton: SGAsyncQueuePool = { SGAsyncQueuePool() }()
    
    private lazy var queues: Array<SGAsyncQueue> = { Array<SGAsyncQueue>() }()
    
    private lazy var maxQueueCount: Int = {
        ProcessInfo.processInfo.activeProcessorCount > 2 ? ProcessInfo.processInfo.activeProcessorCount : 2
    }()
    
    /**
     Get a serial queue with a balanced rule by `taskCount`.
     - Note: The returned queue's  sum is under the CPU active count forever.
     */
    public func getTaskQueue() -> SGAsyncQueue {
        // If the queues is doen't exist, and create a new async queue to do.
        if queues.count < maxQueueCount {
            let asyncQueue: SGAsyncQueue = SGAsyncQueue()
            asyncQueue.taskCount = asyncQueue.taskCount + 1
            queues.append(asyncQueue)
            return asyncQueue
        }
        
        // Find the min task count in queues inside.
        let queueMinTask: Int = queues.map { $0.taskCount }.sorted { $0 > $1 }.first ?? 0
        
        // Find the queue that task count is min.
        guard let asyncQueue: SGAsyncQueue = queues.filter({ $0.taskCount <= queueMinTask }).first else {
            let asyncQueue: SGAsyncQueue = SGAsyncQueue()
            asyncQueue.taskCount = asyncQueue.taskCount + 1
            queues.append(asyncQueue)
            return asyncQueue
        }
        
        asyncQueue.taskCount = asyncQueue.taskCount + 1
        queues.append(asyncQueue)
        return asyncQueue
    }
    
    /**
     Indicate a queue to stop.
     */
    public func stopTaskQueue(_ queue: SGAsyncQueue){
        queue.taskCount = queue.taskCount - 1
        if queue.taskCount <= 0 {
            queue.taskCount = 0
        }
    }  
    
}
