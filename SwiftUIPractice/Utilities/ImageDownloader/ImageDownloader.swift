//
//  ImageDownloader.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/11/25.
//

import Foundation

@MainActor
class ImageDownloader: ObservableObject {
    
    @Published var downloadProgress: Double = 0.0
    
    func downloadImages(from urls: [URL]) async throws -> [Data] {
        
        var completedImages: Int = 0
        
        var result: [Data] = Array(repeating: Data(), count: urls.count)
        
        try await withThrowingTaskGroup(of: (Int, Data).self) { group in
            for (index, url) in urls.enumerated() {
                group.addTask {
                    let (bytesStream, _) = try await URLSession.shared.bytes(from: url)
                    
                    var data = Data()
                    
                    for try await byte in bytesStream {
                        data.append(byte)
                    }
                    
                    return (index, data)
                }
            }
            
            for try await (index, data) in group {
                result[index] = data
                
                completedImages += 1
                self.downloadProgress = Double(completedImages) / Double(urls.count)
            }
        }
        
        return result
    }
    
    func downloadImage(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        
        do {
            let (bytesStream, response) = try await URLSession.shared.bytes(for: request)
            
            let expectedBytes = response.expectedContentLength
            
            var receivedBytes: Int64 = 0
            var data = Data()
            
            for try await byte in bytesStream {
                data.append(byte)
                receivedBytes += 1
                self.downloadProgress = Double(receivedBytes) / Double(expectedBytes)
            }
            
            return data
        } catch {
            throw error
        }
    }
}
