//
//  SGAsyncLayer.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/21.
//

import UIKit
import CoreGraphics
import QuartzCore

/**
 Implements this protocol and override following methods.
 */
@objc protocol SGAsyncDelgate {
    
    /**
     Override this method to custome the async view.
     - Parameter layer: A layer to present view, which is foudation of custome view.
     - Parameter context: Paint.
     - Parameter size: Layer size, type of CGSize.
     - Parameter cancel: A boolean value that tell callback method the status it experienced.
     */
    @objc func asyncDraw(layer: CALayer, in context: CGContext, size: CGSize, isCancel cancel: Bool)
    
}

class SGAsyncLayer: CALayer {
    
    /**
     A boolean value that indicate the layer ought to draw in async mode or sync mode. Sync mode is slow to draw in UI-Thread, and async mode is fast in special sub-thread to draw but the memory is bigger than sync mode. Default is `true`.
     */
    public var isEnableAsyncDraw: Bool = true
    
    /** Current status of operation in current runloop. */
    private var isCancel: Bool = false
    
    override func setNeedsDisplay() {
        self.isCancel = true
        super.setNeedsDisplay()
    }
    
    override func display() {
        self.isCancel = false
        
        // If the view could responsed the delegate, and executed async draw method.
        if let delegate = self.delegate {
            if delegate.responds(to: #selector(SGAsyncDelgate.asyncDraw(layer:in:size:isCancel:))) {
                self.setDisplay(true)
            } else {
                super.display()
            }
        } else {
            super.display()
        }
    }
    
}

extension SGAsyncLayer {
    
    private func setDisplay(_ async: Bool){
        guard let delegate = self.delegate as? SGAsyncDelgate else { return }
        // Get the task queue for async draw process.
        let taskQueue: SGAsyncQueue = SGAsyncQueuePool.singleton.getTaskQueue()

        if async {
            taskQueue.queue.async {
                
                // Decrease the queue task count.
                if self.isCancel {
                    SGAsyncQueuePool.singleton.stopTaskQueue(taskQueue)
                    return
                }
                
                let size: CGSize = self.bounds.size
                let scale: CGFloat = UIScreen.main.nativeScale
                let opaque: Bool = self.isOpaque
                
                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                
                guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
                if opaque {
                    context.saveGState()
                    context.setFillColor(self.backgroundColor ?? UIColor.white.cgColor)
                    context.setStrokeColor(UIColor.clear.cgColor)
                    context.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.fillPath()
                    context.restoreGState()
                }
                
                // Provide an async draw callback method for UIView.
                delegate.asyncDraw(layer: self, in: context, size: size, isCancel: self.isCancel)
                
                // Decrease the queue task count.
                if self.isCancel {
                    SGAsyncQueuePool.singleton.stopTaskQueue(taskQueue)
                    return
                }
                
                guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                
                // End this process.
                SGAsyncQueuePool.singleton.stopTaskQueue(taskQueue)
                DispatchQueue.main.async {
                    self.contents = image.cgImage
                }
                 
            }
        } else {
            
            SGAsyncQueuePool.singleton.stopTaskQueue(taskQueue)
        }
    }
    
}
