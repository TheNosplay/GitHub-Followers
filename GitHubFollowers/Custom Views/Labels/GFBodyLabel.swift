//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 17.02.20.
//

import UIKit

class GFBodyLabel: UILabel {
    
    let preffertFont = UIFont.preferredFont(forTextStyle: .body)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func configure(){
        textColor = .secondaryLabel
        font = preffertFont
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
