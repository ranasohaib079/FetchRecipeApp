//
//  CachedAsyncImage.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

/**
 This file defines a SwiftUI component designed for asynchronous image loading.
 It uses the custom ImageCacheManager to load an image from a URL, caching it in memory and on disk to minimize
 repeated network requests. As the image loads, a placeholder (by default, a ProgressView) is displayed.
 */

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    let placeholder: () -> AnyView

    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder()
            }
        }
        .task {
            if uiImage == nil {
                uiImage = await ImageCacheManager.shared.loadImage(for: url)
            }
        }
    }
}

extension CachedAsyncImage {
    init(url: URL) {
        self.url = url
        self.placeholder = { AnyView(ProgressView()) }
    }
}
