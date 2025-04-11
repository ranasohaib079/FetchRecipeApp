//
//  RecipeRowView.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

/**
 This view represents a single row in the recipe list which displays essential recipe information such as the
 recipe's name, the cuisine type, and a thumbnail image loaded asynchronously via CachedAsyncImage.
 There is also a "View Recipe" link that takes the user to a YouTube video of the recipe.
 */

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                if let url = recipe.photoURLSmall {
                    CachedAsyncImage(url: url)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            if let youtubeURL = recipe.youtubeURL {
                Link("View Recipe", destination: youtubeURL)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}
