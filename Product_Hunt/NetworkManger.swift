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
    
    func getPosts(_ completion: @escaping (Result<[Post]>) -> Void) {
        let postsRequest = makeRequest(for: .posts)
        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
            // Check for errors.
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            // Attempt to decode the data.
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let posts = result.posts
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success(posts))
            }
        }
        
        task.resume()
    }
    
    func getComments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
        let commentsRequest = makeRequest(for: .comments(postId: postId))
        let task = urlSession.dataTask(with: commentsRequest) { data, response, error in
            // Check for errors
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            // Attempt to decode the comment data.
            guard let result = try? JSONDecoder().decode(CommentApiResponse.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success(result.comments))
            }
        }
        
        task.resume()
    }
    
    enum EndPoints {
        case posts
        case comments(postId: Int)
        
        func getPath() -> String {
            switch self {
            case .posts:
                return "posts/all"
            case .comments:
                return "comments"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func getHeaders(token: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Host": "api.producthunt.com"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .posts:
                return [
                    "sort_by": "votes_count",
                    "order": "desc",
                    "per_page": "20",
                    
                    "search[featured]": "true"
                ]
                
            case let .comments(postId):
                return [
                    "sort_by": "votes",
                    "order": "asc",
                    "per_page": "20",
                    
                    "search[post_id]": "\(postId)"
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }
            
            return parameterArray.joined(separator: "&")
        }
        
    } //MARK: EndPoints
    
    // All the code we did before but cleaned up into their own methods
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        // grab the parameters from the endpoint and convert them into a string
        let stringParams = endPoint.paramsToString()
        // get the path of the endpoint
        let path = endPoint.getPath()
        // create the full url from the above variables
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        // build the request
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
        
        return request
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
}
