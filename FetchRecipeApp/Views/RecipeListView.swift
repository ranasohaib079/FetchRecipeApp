//
//  RecipeListView.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/10/25.
//

/**
 This is the main SwiftUI view that displays recipes which fetches recipe data from the API using RecipeService.
 It cycles through different API endpoints (valid, malformed, empty) on refresh, and allows filtering recipes by cuisine.
 The view handles loading, error, and empty states, and leverages Swift Concurrency for networking.
 */

import SwiftUI

struct RecipeListView: View {
    @State private var recipes: [Recipe] = []
    @State private var errorMessage: String? = nil
    @State private var isLoading = false
    
    @State private var endpointIndex = 0
    
    @State private var selectedCuisine: String = "All"

    private let endpoints = [
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json",            // Valid endpoint
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json",     // Malformed data
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"          // Empty data
    ]
    
    private var availableCuisines: [String] {
        let cuisines = recipes.map { $0.cuisine }
        let uniqueCuisines = Set(cuisines).sorted()
        return ["All"] + uniqueCuisines
    }
    
    private var filteredRecipes: [Recipe] {
        if selectedCuisine == "All" {
            return recipes
        } else {
            return recipes.filter { $0.cuisine == selectedCuisine }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading recipes…")
                        .padding()
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 16) {
                        Text("Error")
                            .font(.title)
                            .foregroundColor(.red)
                        Text(errorMessage)
                        
                        Button("Retry") {
                            Task { await loadRecipes() }
                        }
                    }
                } else if recipes.isEmpty {
                    VStack {
                        Text("No recipes available.")
                            .foregroundColor(.secondary)
                        
                        Button("Refresh") {
                            Task { await loadRecipes() }
                        }
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Picker("Cuisine", selection: $selectedCuisine) {
                            ForEach(availableCuisines, id: \.self) { cuisine in
                                Text(cuisine).tag(cuisine)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }
                    
                    List(filteredRecipes) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await loadRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await loadRecipes() }
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                }
            }
            .onAppear {
                Task {
                    await loadRecipes()
                }
            }
        }
    }
    
    @MainActor
    private func loadRecipes() async {
        errorMessage = nil
        isLoading = true
        
        let chosenEndpoint = endpoints[endpointIndex]
        print("Loading recipes from endpoint: \(chosenEndpoint)")
        
        endpointIndex = (endpointIndex + 1) % endpoints.count
        
        do {
            let fetchedRecipes = try await RecipeService.shared.fetchRecipes(from: chosenEndpoint)
            self.recipes = fetchedRecipes
            self.selectedCuisine = "All"
        } catch {
            self.errorMessage = "Error from endpoint \(chosenEndpoint): \(error.localizedDescription)"
            self.recipes = []
        }
        
        isLoading = false
    }
}

