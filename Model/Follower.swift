//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/20/23.
//

import Foundation

struct Follower: Codable, Hashable{ //Hashable for the dataSource in FollowerListVC
    var login: String
    var avatarUrl: String
    
}
