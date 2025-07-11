//
//  NetworkClient.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/10/25.
//

import SwiftUI

final class NetworkClient {
    
    static let shared = NetworkClient()
    private init() {}
    
    func getRequest<T: Decodable>(
        url: URL,
        endpoint: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        do {
            let fullURL = try buildURL(baseURL: url, endpoint: endpoint, queryItems: queryItems)
            
            var request = URLRequest(url: fullURL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            try validate(response)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    func postRequest<T: Decodable, U: Encodable>(
        url: URL,
        endpoint: String,
        queryItems: [URLQueryItem] = [],
        body: U
    ) async throws -> T {
        do {
            let fullURL = try buildURL(baseURL: url, endpoint: endpoint, queryItems: queryItems)
            
            var request = URLRequest(url: fullURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            try validate(response)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    func postDataRequest(
        url: URL,
        endpoint: String,
        queryItems: [URLQueryItem] = [],
        data: Data
    ) async throws {
        do {
            let boundary = UUID().uuidString
            let token = "token"
            let fullURL = try buildURL(baseURL: url, endpoint: endpoint, queryItems: queryItems)
            
            var request = URLRequest(url: fullURL)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (_, response) = try await URLSession.shared.upload(for: request, from: data)
            try validate(response)
        } catch {
            throw error
        }
    }
    
    private func buildURL(baseURL: URL, endpoint: String, queryItems: [URLQueryItem]) throws -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
        (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    
}
