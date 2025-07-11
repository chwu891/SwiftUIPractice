//
//  ImageDownloaderView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/11/25.
//

import SwiftUI

struct ImageDownloaderView: View {
    
    @StateObject private var imageDownloader = ImageDownloader()
    
    let urls = [
        URL(string: "https://picsum.photos/id/101/300")!,
        URL(string: "https://picsum.photos/id/102/300")!,
        URL(string: "https://picsum.photos/id/103/300")!
    ]
    
    @State private var images: [Image] = []
    
    var body: some View {
        VStack {
            ProgressView(value: imageDownloader.downloadProgress)
                .padding()
            Text(String(format: "%.2f%%", imageDownloader.downloadProgress * 100))
            
            ScrollView {
                VStack {
                    ForEach(Array(images.enumerated()), id: \.offset) { _, image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom)
                    }
                }
            }
        }
        .task {
            do {
                let dataList = try await imageDownloader.downloadImages(from: urls)
                
                await MainActor.run {
                    images = dataList.compactMap { data in
                        if let uiImage = UIImage(data: data) {
                            return Image(uiImage: uiImage)
                        }
                        return nil
                    }
                }
            } catch {
                print("❌ Download failed:", error)
            }
        }
    }
    
//    func downloadImages() async throws {
//        try await withThrowingTaskGroup(of: Data.self) { group in
//            for url in urls {
//                group.addTask {
//                    let data = try await imageDownloader.downloadImage(from: url)
//                    return data
//                }
//            }
//            
//            for try await data in group {
//                if let uiImage = UIImage(data: data) {
//                    await MainActor.run {
//                        image = Image(uiImage: uiImage)
//                    }
//                }
//            }
//        }
//    }
//    
//    func downloadImages2() async throws {
//        async let data1 = imageDownloader.downloadImage(from: urls[0])
//        async let data2 = imageDownloader.downloadImage(from: urls[1])
//        async let data3 = imageDownloader.downloadImage(from: urls[2])
//        
//        do {
//            let (d1, d2, d3) = try await (data1, data2, data3)
//            let allData = [d1, d2, d3]
//            
//            for data in allData {
//                if let uiImage = UIImage(data: data) {
//                    await MainActor.run {
//                        image = Image(uiImage: uiImage)
//                    }
//                }
//            }
//        } catch {
//            throw error
//        }
//    }
}

#Preview {
    ImageDownloaderView()
}
