//
//  TaskGroupView.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import SwiftUI


struct TaskGroupView: View {
    private let column = [GridItem(.flexible()), GridItem(.flexible())]
    @State var images: [UIImage] = []
    
    var body: some View {
        LazyVGrid(columns: column, spacing: 0) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            do {
                let images = try await getImageWithTaskGroup()
                self.images = images
            } catch {
                print("error")
            }
            
        }
    }
    
    func getImage() async throws -> UIImage {
        let manager = PhotosDataMananger()
        return try await manager.getRandomImageWithAsync()
    }
    
    func getImage(urlString: String) async throws -> UIImage {
        let manager = PhotosDataMananger()
        return try await manager.getRandomImageWithAsync(urlString: urlString)
    }
    
    
    func getImageWithTaskGroup() async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage?.self,
                                               returning: [UIImage].self) { group in
            
            var resultImages: [UIImage] = []
            let urlStrings = ["https://picsum.photos/200",
                              "https://picsum.photos/200",
                              "https://picsum.photos/200",
                              "https://picsum.photos/200"]
            
            for url in urlStrings {
                group.addTask {
                    try? await getImage(urlString: url)
                }
            }
            
            for try await image in group {
                if let image = image {
                    resultImages.append(image)
                }
            }
            
            return resultImages
            
        }
    }
}

struct TaskGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupView()
    }
}
