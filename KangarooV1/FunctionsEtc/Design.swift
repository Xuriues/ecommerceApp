//
//  Design.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import Foundation
class FloatingLabelInput: UITextField {
    var floatingLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    @IBInspectable
    var _placeholder: String?
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.blue
    
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
            self.floatingLabel.textAlignment = .center
            self.addSubview(self.floatingLabel)
            self.layer.borderColor = self.activeBorderColor.cgColor
            
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -10).isActive = true // Place our label 10 pts above the text field
            self.placeholder = ""
        }
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
}
extension UITextField {
  func setBottomBorder() {
    self.borderStyle = .none
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
  }
}

func setupCell(cell:UICollectionViewCell)
{
    cell.layer.cornerRadius = 10
    cell.layer.borderColor = UIColor.lightGray.cgColor

    cell.layer.backgroundColor = UIColor.white.cgColor
    cell.layer.shadowColor = UIColor.gray.cgColor
    cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
    cell.layer.shadowRadius = 2.0
    cell.layer.shadowOpacity = 1.0
    cell.layer.masksToBounds = false
}
extension UIColor
{

    static let tabBarColor = UIColor().colorFromHex("#CAD5E3")
    static let mainBg = UIColor().colorFromHex("#E8E9EB")
    func colorFromHex(_ hex:String ) -> UIColor
    {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#")
        {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6
        {
            return UIColor.black
        }
        var rgb : UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha: 1.0)
    }
}



class ActivityIndicatorView
{
    var view: UIView!

var activityIndicator: UIActivityIndicatorView!

var title: String!

init(title: String, center: CGPoint, width: CGFloat = 200.0, height: CGFloat = 50.0)
{
    self.title = title

    let x = center.x - width/2.0
    let y = center.y - height/2.0

    self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    self.view.backgroundColor = .mainBg
    self.view.layer.cornerRadius = 10

    self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    self.activityIndicator.color = UIColor.gray
    self.activityIndicator.hidesWhenStopped = false

    let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
    titleLabel.text = title
    titleLabel.textColor = UIColor.black

    self.view.addSubview(self.activityIndicator)
    self.view.addSubview(titleLabel)
}

func getViewActivityIndicator() -> UIView
{
    return self.view
}

func startAnimating()
{
    self.activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
}

func stopAnimating()
{
    self.activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
    self.view.removeFromSuperview()
}
}

