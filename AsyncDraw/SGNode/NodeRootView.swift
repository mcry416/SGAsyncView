//
//  NodeRootView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/6/3.
//

import UIKit

class NodeRootView: UIView, SGAsyncDelgate {
    
    override class var layerClass: AnyClass {
        SGAsyncLayer.self
    }
    
    public var subNodes: Array<NodeLayerDelegate> = { Array<NodeLayerDelegate>() }()

}

// MARK: - Draw Node
extension NodeRootView {
    
    @objc private func drawTask() {
        self.layer.setNeedsDisplay()
    }
    
    public func addSubNode(_ node: NodeLayerDelegate) {
        node.willLoadToSuperView()
        self.subNodes.append(node)
        SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit()
    }
    
    func asyncDraw(layer: CALayer, in context: CGContext, size: CGSize, isCancel cancel: Bool) {
        if cancel {
            return
        }
        
        drawNodeImages(layer: layer, in: context, size: size)
        drawNodeLabels(layer: layer, in: context, size: size)
        drawNodeButtons(layer: layer, in: context, size: size)
    }
    
    private func drawNodeButtons(layer: CALayer, in context: CGContext, size: CGSize) {
        let nodes: Array<NodeLayerDelegate> = self.subNodes.filter { $0.isMember(of: NodeButton.self) }
        let nodeButtons: Array<NodeButton> = nodes.map { $0 as! NodeButton }
        
        nodeButtons.forEach { button in
            let tempFrame: CGRect = CGRect(x: button.frame.minX,
                                           y: layer.bounds.height - button.frame.maxY,
                                           width: button.frame.width,
                                           height: button.frame.height)
            let drawPath: CGMutablePath = CGMutablePath()
            drawPath.addRect(tempFrame)
            
            UIColor(cgColor: button.backgroundColor.cgColor).setFill()
            let bezierPath: UIBezierPath = UIBezierPath(roundedRect: tempFrame, cornerRadius: button.cornerRadius)
            bezierPath.lineCapStyle = CGLineCap.round
            bezierPath.lineJoinStyle = CGLineJoin.round
            bezierPath.fill()
            
            let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
            style.lineSpacing = 3
            style.alignment = .center
            style.lineBreakMode = .byTruncatingTail
            style.paragraphSpacing = 5
            
            let attributes: Dictionary<NSAttributedString.Key, Any> = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: button.textColor,
                NSAttributedString.Key.backgroundColor: button.backgroundColor,
                NSAttributedString.Key.paragraphStyle: style,
            ]
            let attributedText: NSAttributedString = NSAttributedString(string: button.text, attributes: attributes)
            
            let ctfFrameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributedText)
            let cfAttributes: CFDictionary = [
                kCTFrameProgressionAttributeName: CTFrameProgression.topToBottom.rawValue as CFNumber
            ] as CFDictionary
            let ctfFrame: CTFrame = CTFramesetterCreateFrame(ctfFrameSetter, CFRange(location: 0, length: attributedText.length), drawPath, cfAttributes)
//            let line = CTLineCreateWithAttributedString(attributedText)
//            let offset = CTLineGetPenOffsetForFlush(line, 0.5, button.frame.width)
//            var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
//            CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
//            let lineHeight = ascent + descent + leading
            context.textPosition = CGPoint(x: button.frame.width, y: (button.frame.height - 10)/2.0)
//            CTLineDraw(line, context)
            CTFrameDraw(ctfFrame, context)
            
            button.didLoadToSuperView()
        }
    }
    
    private func drawNodeLabels(layer: CALayer, in context: CGContext, size: CGSize) {
        let nodes: Array<NodeLayerDelegate> = self.subNodes.filter { $0.isMember(of: NodeLabel.self) }
        let nodeLabels: Array<NodeLabel> = nodes.map { $0 as! NodeLabel }
        
        nodeLabels.forEach { label in
            let tempFrame: CGRect = CGRect(x: label.frame.minX,
                                           y: layer.bounds.height - label.frame.maxY,
                                           width: label.frame.width,
                                           height: label.frame.height)
            let drawPath: CGMutablePath = CGMutablePath()
            drawPath.addRect(tempFrame)
            
            let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
            style.lineSpacing = 3
            style.alignment = .left
            style.lineBreakMode = .byTruncatingTail
            style.paragraphSpacing = 5
            
            let attributes: Dictionary<NSAttributedString.Key, Any> = [
                NSAttributedString.Key.font: label.font,
                NSAttributedString.Key.foregroundColor: label.textColor,
                NSAttributedString.Key.backgroundColor: label.backgroundColor,
                NSAttributedString.Key.paragraphStyle: style,
            ]
            let attributedText: NSAttributedString = NSAttributedString(string: label.text, attributes: attributes)
            
            let ctfFrameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributedText)
            let ctfFrame: CTFrame = CTFramesetterCreateFrame(ctfFrameSetter, CFRange(location: 0, length: attributedText.length), drawPath, nil)
            CTFrameDraw(ctfFrame, context)
            
            label.didLoadToSuperView()
        }
        
    }
    
    private func drawNodeImages(layer: CALayer, in context: CGContext, size: CGSize) {
        let nodes: Array<NodeLayerDelegate> = self.subNodes.filter { $0.isMember(of: NodeImageView.self) }
        let nodeImageViews: Array<NodeLayerDelegate> = nodes.map { $0 as! NodeImageView }
        
        let size: CGSize = layer.bounds.size
        context.textMatrix = CGAffineTransformIdentity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        
        nodeImageViews.forEach {
            if let image = $0.contents as? UIImage, let cgImage = image.cgImage {
                context.draw(cgImage, in: $0.frame)
            }
        }
    }
    
}

// MARK: - Touch Process
extension NodeRootView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = event?.touches(for: self)?.first else { return }
        let touchPoint: CGPoint = touch.location(in: self)
        
        for node in self.subNodes {
            let isInX: Bool = touchPoint.x >= node.frame.minX && touchPoint.x <= node.frame.maxX
            let isInY: Bool = touchPoint.y >= node.frame.minY && touchPoint.y <= node.frame.maxY
            if isInX && isInY {
                node.didReceiveTapSignal()
                break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = event?.touches(for: self)?.first else { return }
        let touchPoint: CGPoint = touch.location(in: self)
        
        for node in self.subNodes {
            let isInX: Bool = touchPoint.x >= node.frame.minX && touchPoint.x <= node.frame.maxX
            let isInY: Bool = touchPoint.y >= node.frame.minY && touchPoint.y <= node.frame.maxY
            if isInX && isInY {
                node.didReceiveClickSignal()
                break
            }
        }
    }
    
}
