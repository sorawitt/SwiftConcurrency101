//
//  AsyncLetView.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import SwiftUI

struct AsyncLetView: View {
    private let column = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var images: [UIImage] = []
    
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
                let image1 = try await getImage()
                images.append(image1)

                let image2 = try await getImage()
                images.append(image2)

                let image3 = try await getImage()
                images.append(image3)

                let image4 = try await getImage()
                images.append(image4)
                
                
//                async let fetchImage1 = getImage()
//                async let fetchImage2 = getImage()
//                async let fetchImage3 = getImage()
//                async let fetchImage4 = getImage()
//
//                let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
//
//                images.append(contentsOf: [image1, image2, image3, image4])
                
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
