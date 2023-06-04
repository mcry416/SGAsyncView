//
//  SGALTranscation.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/21.
//

import Foundation

final fileprivate class AtomicTask: NSObject {
    
    public var target: NSObject!
    public var funcPtr: Selector!
    
    init(target: NSObject!, funcPtr: Selector!) {
        self.target = target
        self.funcPtr = funcPtr
    }
    
    override var hash: Int {
        target.hash + funcPtr.hashValue
    }
    
}

final class SGALTranscation {
    
    /** The task that need process in current runloop. */
    private static var tasks: Set<AtomicTask> = { Set<AtomicTask>() }()
    
    /** Create a SGAsyncLayer Transcation task. */
    public init (target: NSObject, funcPtr: Selector) {
        SGALTranscation.tasks.insert(AtomicTask(target: target, funcPtr: funcPtr))
    }
    
    /** Listen the runloop's change, and execute callback handler to process task. */
    private func initTask() {
        DispatchQueue.once(token: "sg_async_layer_transcation") {
            let runloop    = CFRunLoopGetCurrent()
            let activities = CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue
            let observer   = CFRunLoopObserverCreateWithHandler(nil, activities, true, 0xFFFFFF) { (ob, ac) in
                guard SGALTranscation.tasks.count > 0 else { return }
                SGALTranscation.tasks.forEach { $0.target.perform($0.funcPtr) }
                SGALTranscation.tasks.removeAll()
            }
            CFRunLoopAddObserver(runloop, observer, .defaultMode)
        }
    }
    
    /** Commit  the draw task into runloop. */
    public func commit(){
        initTask()
    }
    
}


extension DispatchQueue {
    
    private static var _onceTokenDictionary: [String: String] = { [: ] }()
    
    /** Execute once safety. */
    static func once(token: String, _ block: (() -> Void)){
        defer { objc_sync_exit(self) }
        objc_sync_enter(self)
        
        if _onceTokenDictionary[token] != nil {
            return
        }

        _onceTokenDictionary[token] = token
        block()
    }
    
}
