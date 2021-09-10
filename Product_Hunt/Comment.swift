//
//  Comment.swift
//  Product_Hunt
//
//  Created by Jimenez on 9/10/21.
//

import UIKit

struct Comment: Decodable {
 let id: Int
 let body: String
}

struct CommentApiResponse: Decodable {
   let comments: [Comment]
}
