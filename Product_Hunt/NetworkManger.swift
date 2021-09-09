//
//  NetworkManger.swift
//  Product_Hunt
//
//  Created by Jimenez on 9/8/21.
//

import UIKit


class NetworkManager {
    let urlSession = URLSession.shared
    var baseURL = "https://api.producthunt.com/v1/"
    var token = "gtVkXULb38TvvII6c_ilDMDQDzawhWtozXU-HdcKPp0"
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
        // Construct the URL to get posts from API.
        let query = "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        let fullURL = URL(string: baseURL + query)!
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = "GET"
        // Set up header with API Token.
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "Host": "api.producthunt.com"
        ]
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            // Check for errors.
            if let error = error {
                print(error)
                return
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return
            }
            
            // Attempt to decode the data.
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return
            }
            
            let posts = result.posts
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        
        task.resume()
    }
}
