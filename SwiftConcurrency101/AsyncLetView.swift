//
//  AsyncLetView.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import SwiftUI

class AsyncLetViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    private let manager = PhotosDataMananger()
    
    func getImages() async throws {
        let image1 = try await manager.getRandomImageWithAsync()
        let image2 = try await manager.getRandomImageWithAsync()
        let image3 = try await manager.getRandomImageWithAsync()
        let image4 = try await manager.getRandomImageWithAsync()
        let image5 = try await manager.getRandomImageWithAsync()
        images.append(contentsOf: [image1, image2, image3, image4, image5])
    }
}

struct AsyncLetView: View {
    @StateObject private var viewModel = AsyncLetViewModel()
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
                async let fetchImage1 = getImage()
                async let fetchImage2 = getImage()
                async let fetchImage3 = getImage()
                async let fetchImage4 = getImage()

                let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)

                images.append(contentsOf: [image1, image2, image3, image4])
                
//                let image1 = try await getImage()
//                images.append(image1)
//
//                let image2 = try await getImage()
//                images.append(image2)
//
//                let image3 = try await getImage()
//                images.append(image3)
//
//                let image4 = try await getImage()
//                images.append(image4)
                
            } catch {
                print("error")
            }
            
        }
    }
    
    func getImage() async throws -> UIImage {
        let manager = PhotosDataMananger()
        return try await manager.getRandomImageWithAsync()
    }
}

struct AsyncLetView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetView()
    }
}
