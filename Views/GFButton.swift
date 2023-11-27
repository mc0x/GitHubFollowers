//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/16/23.
//

import UIKit

class GFButton: UIButton {
    //override when you want to create a custom button (you want to overreide the default settings)
    override init(frame: CGRect) {
        super.init(frame: frame) //making sure all the UIButton build runs first
        //custom code
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Initialize the class with perameters
    init(backgroundColor: UIColor, title: String){
        super.init(frame: .zero) //when you initialize a button you have to give it height/width x/y coordinates
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline) //dynamic type
        translatesAutoresizingMaskIntoConstraints = false //use Auto Layout
        
    }
    
    func set(background: UIColor, title: String) {
        self.backgroundColor = background
        setTitle(title, for: .normal)
    }
    
}
