

import UIKit

class ImageKey: KeyboardKey {
    
    var imageSizeToScale = CGFloat(20)
    
    var image: UIImageView? {
        willSet {
            let anImage = image
            anImage?.removeFromSuperview()
        }
        didSet {
            if let imageView = image {
                self.addSubview(imageView)
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                self.redrawImage()
                updateColors()
            }
        }
    }

    func setImageSizeToScaleGC(_ imageSizeToScale : CGFloat) {
        self.imageSizeToScale = imageSizeToScale
    }
    
    override func updateColors() {
        super.updateColors()
        
        let switchColors = self.isHighlighted || self.isSelected
        
        if switchColors {
            if let downTextColor = self.downTextColor {
                self.image?.tintColor = downTextColor
            }
            else {
                self.image?.tintColor = self.textColor
            }
        }
        else {
            self.image?.tintColor = self.textColor
        }
    }
    
    override func refreshShapes() {
        super.refreshShapes()
        self.redrawImage()
    }
    
    func redrawImage() {
        if let image = self.image {
            let imageSize = CGSize(width: imageSizeToScale, height: imageSizeToScale)
            let imageOrigin = CGPoint(
                x: (self.bounds.width - imageSize.width) / CGFloat(2),
                y: (self.bounds.height - imageSize.height) / CGFloat(2))
            var imageFrame = CGRect.zero
            imageFrame.origin = imageOrigin
            imageFrame.size = imageSize
            
            image.frame = imageFrame
        }
    }
}
