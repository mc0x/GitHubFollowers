//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 7/19/23.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(background: .systemPurple, title: "GitHub Profile")
        
        
        
    }
}
