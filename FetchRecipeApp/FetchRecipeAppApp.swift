//
//  FetchRecipeAppApp.swift
//  FetchRecipeApp
//
//  Created by Sohaib Rana on 4/9/25.
//

/**
 This is the app’s entry point. It defines the main structure of the SwiftUI app and sets up the  initial view (RecipeListView) within a window group.
*/

import SwiftUI

@main
struct FetchRecipeAppApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
    }
}
