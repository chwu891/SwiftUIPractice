//
//  RemotePostService.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/11/25.
//

import Foundation

struct RemotePostService {
    func fetchAllPosts() async throws -> [Post] {
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
        let endpoint = "posts"
        
        let posts: [Post] = try await NetworkClient.shared.getRequest(
            url: baseURL,
            endpoint: endpoint
        )
        
        return posts
    }
}
