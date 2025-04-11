//
//  RecipeServiceTest.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

import XCTest
@testable import FetchRecipeApp

final class RecipeServiceTests: XCTestCase {

    func testValidRecipesDecoding() async throws {
        let json = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Margherita Pizza",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "uuid": "1234-5678",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com/watch?v=abcd"
                }
            ]
        }
        """
        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(RecipeResponse.self, from: jsonData)
            XCTAssertEqual(response.recipes.count, 1)
            XCTAssertEqual(response.recipes.first?.name, "Margherita Pizza")
        } catch {
            XCTFail("Decoding should not fail: \(error.localizedDescription)")
        }
    }
    
    func testEmptyDataThrowsError() async {
        let json = """
        {
            "recipes": []
        }
        """
        let jsonData = Data(json.utf8)
        do {
            _ = try JSONDecoder().decode(RecipeResponse.self, from: jsonData)
            XCTAssertTrue(true)
        } catch {
            XCTFail("Decoding empty list should not throw: \(error.localizedDescription)")
        }
    }
}
