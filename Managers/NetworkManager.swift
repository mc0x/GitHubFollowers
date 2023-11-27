//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Mayra Cortez on 6/21/23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init(){
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    //we are passing in a usernmaen and page number along with a closure, and gong to return either an error of followers or an error message.
    //Create an endpoint, that we are going to create our URL from
    //once we get valid url, if we don't, return an error message. If we do, move on to Task.
    //In Task -> if there is an error, print out error and exit.
    //if the response is valid and response of 200, move onto the list. else, error message and return
    //if data is valid move on, else error message and return
    //create a decoder from Codable
    //set our key decoding strategy to convert from snakeCase
    //create an array of followers, TRY to decode the data into a type of an array of followers from the good "data"
    //if that goes well, call our completed(followers, nil) handler, where we pass in the followers and no error message.
    //and throw the error message if not.
    //call task.resume(), that's what starts this off.
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void){ //ErrorMessage from Enum to return
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else{
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else{
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))

            }catch {

                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void){ //ErrorMessage from Enum to return
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else{
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else{
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))

            }catch {

                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
    
    
//    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
//
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else{
//            throw GFError.invalidUsername
//        }
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            throw GFError.invalidResponse
//
//        }
//
//        do {
//            return try decoder.decode([Follower].self, from: data)
//
//
//        }catch {
//            throw GFError.invalidData
//        }
//    }
    
    
}






