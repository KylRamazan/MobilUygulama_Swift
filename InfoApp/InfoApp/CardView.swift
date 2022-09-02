import Foundation
import UIKit

@IBDesignable class CardView : UIView{
    
    @IBInspectable var cornerRadius : CGFloat = 10
    var ofsetWidth : CGFloat = 5
    var ofsetHeight : CGFloat = 5
    var ofsetShadowOpacity : Float = 5
    @IBInspectable var colour = UIColor.systemGray4
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = self.colour.cgColor
        layer.shadowOffset = CGSize(width: self.ofsetWidth, height: self.ofsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        layer.shadowOpacity = self.ofsetShadowOpacity
    }
    
}
