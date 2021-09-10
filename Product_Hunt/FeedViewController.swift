//
//  FeedViewController.swift
//  Product_Hunt
//
//  Created by Jimenez on 8/25/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [Post] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        func updateFeed() {
            // call our network manager's getPosts method to update our feed with posts
            networkManager.getPosts() { result in
                switch result {
                case let .success(posts):
                    self.posts = posts
                case let .failure(error):
                    print(error)
                }
            }
        }
        updateFeed()
    }
    
    
}

// MARK: UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    /// Determines how many cells will be shown on the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    /// Creates and configures each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post =  posts[indexPath.row]
        cell.post = post
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Get the commentsView from the storyboard
        guard let commentsView = storyboard.instantiateViewController(withIdentifier: "commentsView") as? CommentsViewController else {
            return
        }
        // add mock comments
        commentsView.comments = ["Blah blah blah!", "Good app.", "Wow."]
        navigationController?.pushViewController(commentsView, animated: true)
    }
}
