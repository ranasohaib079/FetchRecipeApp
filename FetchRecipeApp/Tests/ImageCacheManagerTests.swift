//
//  ImageCacheManagerTests.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

import XCTest
@testable import FetchRecipeApp

final class ImageCacheManagerTests: XCTestCase {
    func testImageCaching() async {
        guard let url = URL(string: "https://dummyimage.com/150") else {
            XCTFail("Invalid URL")
            return
        }
        
        ImageCacheManager.shared.clearCache()
        
        let image1 = await ImageCacheManager.shared.loadImage(for: url)
        XCTAssertNotNil(image1, "Image should be loaded from network.")
        
        let image2 = await ImageCacheManager.shared.loadImage(for: url)
        XCTAssertNotNil(image2, "Image should be loaded from cache.")
        
        XCTAssertEqual(image1?.pngData(), image2?.pngData(), "Cached images must match.")
    }
}
