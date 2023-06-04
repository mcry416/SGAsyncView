//
//  NudeButton.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/6/3.
//

import UIKit

class NodeButton: NSObject, NodeLayerDelegate {
    
    var text: String = ""
    
    var contents: (Any & NSObject)?
    
    var textColor: UIColor = .black
    
    var cornerRadius: CGFloat = 5
    
    var backgroundColor: UIColor = .white
    
    var frame: CGRect = .zero
    
    var hidden: Bool = false
    
    var alpha: CGFloat = 1.0
    
    var superView: NodeLayerDelegate?
    
    var paintSignal: Bool = false
    
    private var didReceiveTapBlock: (() -> Void)?
    
    private var didReceiveClickBlock: (() -> Void)?
    
    func setOnTapListener(_ listerner: (() -> Void)?) {
        didReceiveTapBlock = {
            listerner?()
        }
    }
    
    func setOnClickListener(_ listerner: (() -> Void)?) {
        didReceiveClickBlock = {
            listerner?()
        }
    }
    
    func didReceiveTapSignal() {
        didReceiveTapBlock?()
    }
    
    func didReceiveClickSignal() {
        didReceiveClickBlock?()
    }
    
    func removeFromSuperView() {
        
    }
    
    func willLoadToSuperView() {
        
    }
    
    func didLoadToSuperView() {
        
    }
    
    func setNeedsDisplay() {
        
    }
    
}
