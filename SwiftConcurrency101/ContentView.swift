//
//  ContentView.swift
//  SwiftConcurrency101
//
//  Created by Sorawit Trutsat on 27/7/2565 BE.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private var manager = PhotosDataMananger()
    
    func fetchImage() {
        manager.getRandomImage { result in
            switch result {
            case let .success(image):
                self.image = image
            case let .failure(error):
                print("XD \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            viewModel.fetchImage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
