//
//  SearchViewController.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/16/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    let logoImageView = UIImageView() //for image
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers") //using the GFButton init parameters
    
    var isUsernameEntered: Bool{
        return !usernameTextField.text!.isEmpty //checks to see if a username was entered
    }

    override func viewDidLoad() { //is called when it is loaded, which is once
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageVIew()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {  //using viewWillAppear calls this every time the view appears
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) //true from FollowersListViewController
    }

//    FUNCTIONS     //
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC(){
        guard isUsernameEntered else{
            presentGFAlert(title: "Empty Username", message: "Please enter a username.  We need to know who to look for 😃", buttonTitle: "Ok")
            return
            
            }
        
        let followerListVC = FollowerListViewController() //create the data
        followerListVC.username = usernameTextField.text //configure the data you want to pass
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true) //push VC onto the stack
    }
    
    func configureLogoImageVIew() {
        view.addSubview(logoImageView) //don't forget to add it to the subview
        logoImageView.translatesAutoresizingMaskIntoConstraints = false //set auto layout
        logoImageView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self //self being the SearchViewController
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        //// bottom components are pinned to the SafeAreaLayoutGuide and the bottom has negative numbers as constant
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

//delegate
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
