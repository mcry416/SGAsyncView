//
//  NodeLayerDelegate.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/6/3.
//

import UIKit

protocol NodeLayerDelegate: NSObject {
    
    var contents: (Any & NSObject)? { set get }
    
    var backgroundColor: UIColor { set get }
    
    var frame: CGRect { set get }
    
    var hidden: Bool { set get }
    
    var alpha: CGFloat { set get }
    
    var superView: NodeLayerDelegate? { get }
    
    var paintSignal: Bool { set get }
    
    func setOnTapListener(_ listerner: (() -> Void)?)
    
    func setOnClickListener(_ listerner: (() -> Void)?)
    
    func didReceiveTapSignal()
    
    func didReceiveClickSignal()
    
    func removeFromSuperView()
    
    func willLoadToSuperView()
    
    func didLoadToSuperView()
    
    func setNeedsDisplay()
    
}
