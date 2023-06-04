//
//  SyncLabel.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/28.
//

import UIKit

class SyncLabel: UIView {
    
    public var text: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var textColor: UIColor = .black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.setNeedsDisplay()
        }
    }


    override func draw(_ rect: CGRect) {
        let size: CGSize = self.bounds.size
        let scale: CGFloat = self.layer.contentsScale
        let opaque: Bool = self.isOpaque
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)

        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        if opaque {
            context.saveGState()
            context.setFillColor(self.backgroundColor?.cgColor ?? UIColor.white.cgColor)
            context.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            context.fillPath()
            context.restoreGState()
        }
        
        context.textMatrix = CGAffineTransformIdentity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        
        let drawPath: CGMutablePath = CGMutablePath()
        drawPath.addRect(CGRect(origin: .zero, size: size))
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes: Dictionary<NSAttributedString.Key, Any> = [
            NSAttributedString.Key.font: self.font,
            NSAttributedString.Key.foregroundColor: self.textColor,
            NSAttributedString.Key.paragraphStyle: style,
        ]
        let attributedString: NSAttributedString = NSAttributedString(string: self.text, attributes: attributes)
        let ctfFrameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let ctfFrame: CTFrame = CTFramesetterCreateFrame(ctfFrameSetter, CFRange(location: 0, length: attributedString.length), drawPath, nil)
        CTFrameDraw(ctfFrame, context)
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        self.layer.contents = image
    }

   
}
