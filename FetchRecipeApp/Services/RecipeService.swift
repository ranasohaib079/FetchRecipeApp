//
//  RecipeService.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

/**
 This file contains the RecipeService class, which is responsible for fetching recipe data from the given API endpoint.
 It uses Swift's async/await for asynchronous operations, decodes JSON data into Recipe objects, and handles errors
 such as invalid URLs, empty data, or decoding failures.
 */

import Foundation

enum RecipeServiceError: Error, LocalizedError {
    case invalidURL
    case emptyData
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .emptyData:
            return "The recipe list is empty."
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}

class RecipeService {
    static let shared = RecipeService()
    private init() {}
    
    func fetchRecipes(from endpoint: String) async throws -> [Recipe] {
        guard let url = URL(string: endpoint) else {
            throw RecipeServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            if decoded.recipes.isEmpty {
                throw RecipeServiceError.emptyData
            }
            return decoded.recipes
        } catch {
            throw RecipeServiceError.decodingError(error)
        }
    }
}
