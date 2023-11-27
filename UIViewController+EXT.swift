//
//  UIViewController+EXT.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/19/23.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    

    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
        
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertViewController(title: "Something went wrong", message: "Unable to meet your task at this time, please try again", buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
        
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds) //initialize container as UIView
        view.addSubview(containerView) //add subview
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 } //animate it from 0 to 0.8
        
        let activityIndicator = UIActivityIndicatorView(style: .large) //create activyIndicator
        containerView.addSubview(activityIndicator) //add activytIndicator to the subview
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false //set autolayout
        
        NSLayoutConstraint.activate([ //set constraints to center
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        activityIndicator.startAnimating() //start animating
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
        
    }
    
    func showEmptyStateView(with message: String, in view: UIView) { //passing the message we want to show, and UIView we want to show it on
        let emptyStateView = GFEmptyStateView(message: message) //created empty stateView
        emptyStateView.frame = view.bounds //set the bounds
        view.addSubview(emptyStateView) //add to the subview (EmptyStateView
    }
}
