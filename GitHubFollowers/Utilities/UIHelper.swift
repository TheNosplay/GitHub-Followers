//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import UIKit

enum UIHelper{
    
    static func createThreeColumFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        let width                            = view.bounds.width
        let padding : CGFloat                = 12
        let minimumItemSpacing : CGFloat     = 10
        let availableWidth                   = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                        = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    static func heightForUILabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
