//
//  AsyncAwaitImageView.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import SwiftUI

class AsyncAwaitImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let manager = PhotosDataMananger()
    
    func getImageWithAsync() async {
        self.image = try? await manager.getRandomImageWithAsync()
    }
}

struct AsyncAwaitImageView: View {
    @StateObject private var viewModel = AsyncAwaitImageViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getImageWithAsync()
        }
    }
}

struct AsyncAwaitImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitImageView()
    }
}
