import UIKit
import Foundation


extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributedString = NSMutableAttributedString(string: title)
        if let nFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : nFont],
                                range:  NSMakeRange(0, title.count))
            
             }
        if let nColor = color {
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor : nColor],//3
                    range: NSMakeRange(0, title.count))
                self.view.tintColor = nColor
        }
              self.setValue(attributedString, forKey: "attributedTitle")//4
        
    }
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }



}

