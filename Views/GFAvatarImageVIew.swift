//
//  GFAvatarImageVIew.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/21/23.
//

import UIKit

class GFAvatarImageVIew: UIImageView {
    
    let cache = NetworkManager.shared.cache
    
    let placeHolderimage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderimage
        translatesAutoresizingMaskIntoConstraints = false //set autolayout
    }
             
    func downloadImage(from urlString: String){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){ //if the image is already into the cache, just setting the image to that image and exiting
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return } //download the image
            if error != nil { return } //check all the errors
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return } //check all the errors
            guard let data = data else { return } //check all the errors
            
            guard let image = UIImage(data: data) else { return } //check all the errors
            self.cache.setObject(image, forKey: cacheKey) //setting it into the cache
            
            DispatchQueue.main.async { //setting the image to the image on imageVIew on main thread
                self.image = image
            }
        }
        
        task.resume()
    }
}
