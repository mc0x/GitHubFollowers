//
//  GFTextField.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/18/23.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor //layer.bordercolor requres UIColor.system...cgColor
        
        textColor = .label  //black on lightmode and white on darkmode
        tintColor = .label //cursor color
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2) //dynamic type
        minimumFontSize = 12 //set min font size with dynamic
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no  //turn of auto correct for this text field
        returnKeyType = .go  //what the keyboard return key says
        
        placeholder = "Enter a username"
    }
    
}


