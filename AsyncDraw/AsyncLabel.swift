//
//  AsyncLabel.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/18.
//

import UIKit

class AsyncLabel: UIView, SGAsyncDelgate {
    
    public var text: String = "" {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }

    public var textColor: UIColor = .black {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }

    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    public var lineSpacing: CGFloat = 3 {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    public var textAlignment: NSTextAlignment = .left {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }

    public var attributedText: NSAttributedString? {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    public var size: CGSize {
        get { getTextSize() }
    }
    
    override class var layerClass: AnyClass {
        SGAsyncLayer.self
    }
    
    @objc func drawTask(){
        self.layer.setNeedsDisplay()
    }
    
    func asyncDraw(layer: CALayer, in context: CGContext, size: CGSize, isCancel cancel: Bool) {
        if cancel {
            return
        }
        
        let size: CGSize = layer.bounds.size
        context.textMatrix = CGAffineTransformIdentity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        
        let drawPath: CGMutablePath = CGMutablePath()
        drawPath.addRect(CGRect(origin: .zero, size: size))
        
        self.attributedText = self.generateAttributedString()
        guard let attributedText = self.attributedText else { return }
        
        let ctfFrameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let ctfFrame: CTFrame = CTFramesetterCreateFrame(ctfFrameSetter, CFRange(location: 0, length: attributedText.length), drawPath, nil)
        CTFrameDraw(ctfFrame, context)
    }
    
    private func generateAttributedString() -> NSAttributedString {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = self.lineSpacing
        style.alignment = self.textAlignment
        style.lineBreakMode = self.lineBreakMode
        style.paragraphSpacing = 5
        
        let attributes: Dictionary<NSAttributedString.Key, Any> = [
            NSAttributedString.Key.font: self.font,
            NSAttributedString.Key.foregroundColor: self.textColor,
            NSAttributedString.Key.backgroundColor: UIColor.clear,
            NSAttributedString.Key.paragraphStyle: style,
        ]

        return NSAttributedString(string: self.text, attributes: attributes)
    }
    
    private func getTextSize() -> CGSize {
        guard let attributedText = self.attributedText else { return .zero }
        return attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFLOAT_MAX),
                                           context: nil).size
    }
    
}
