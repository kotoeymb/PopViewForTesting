//
//  plantoButton.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/11/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit
@IBDesignable

class plantoButton: UIButton {
    
        @IBInspectable var cornerRadius: CGFloat = 0 {
            didSet {
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = cornerRadius > 0
            }
        }
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
        @IBInspectable var borderColor: UIColor? {
            didSet {
                layer.borderColor = borderColor?.cgColor
            }
        }
}
