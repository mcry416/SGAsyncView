//
//  AsyncImageView.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/31.
//

import UIKit

class AsyncImageView: UIView, SGAsyncDelgate {
    
    public var image: UIImage? {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    public var quality: CGFloat = 0.9 {
        didSet { SGALTranscation(target: self, funcPtr: #selector(drawTask)).commit() }
    }
    
    override class var layerClass: AnyClass {
        SGAsyncLayer.self
    }
    
    @objc func drawTask() {
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
        
        guard let image = self.image else { return }
        guard let jpedData: Data = image.jpegData(compressionQuality: self.quality) else { return }
        guard let cgImage = UIImage(data: jpedData)?.cgImage else { return }
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
    }

}
