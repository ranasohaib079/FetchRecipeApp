# Fetch Recipe App - Take Home Project

## Summary
This project is a SwiftUI-based recipe app built as a take-home challenge for Fetch. It retrieves recipes from a remote API and displays each recipe's name, photo, and cuisine type. The app uses Swift Concurrency (async/await) for networking and implements a custom image caching solution to minimize network usage. Additional features include error handling, pull-to-refresh functionality, and a cuisine filter that allows users to filter recipes by nationality type.

### Screenshots / Demo Video
[![Demo Video](https://img.youtube.com/vi/8RGS_wE_sq4/0.jpg)](https://youtu.be/8RGS_wE_sq4)

## Focus Areas
- **Swift Concurrency & Networking:**  
  Utilized async/await for all asynchronous operations (network requests and image loading) to keep code clean and modern.
- **Custom Image Caching:**  
  Developed a solution for caching images both in-memory (using NSCache) and on-disk to reduce redundant network calls.
- **Error Handling:**  
  Implemented robust error handling to gracefully manage malformed or empty data from the API.
- **Modern UI with SwiftUI:**  
  Built the user interface entirely in SwiftUI, complete with pull-to-refresh, a refresh button, and a cuisine filter for a better user experience.

## Time Spent
I spent approximately 20 hours on this project:
- **Planning & Architecture:** 1 hours.
- **Networking & Data Handling:** 4 hours.
- **Custom Caching Implementation:** 4 hours.
- **UI Development with SwiftUI:** 6 hours.
- **Writing Unit Tests:** 3 hours.
- **Debugging & Final Polishing:** 2 hours.

## Trade-offs and Decisions
- **Custom Image Caching:**  
  Instead of relying on URLCache, a custom solution was implemented to demonstrate in-depth understanding of network operations and file I/O.
- **Endpoint Testing:**  
  Included endpoints to simulate valid, malformed, and empty data scenarios. This added complexity for testing error handling but is beneficial in understanding how the app reacts under different conditions.
- **Static Data Source:**  
  The API used returns static data, so repeated refreshes may not display new recipes. In a production environment, dynamic endpoints or backend updates would provide fresh data.

## Weakest Part of the Project
The weakest part of the project is the simplistic error handling for malformed data. In a production app, a more robust solution might involve partial data recovery or more detailed user feedback. Additionally, the custom caching mechanism could be further enhanced by adding features such as cache expiration and cleanup.

## Additional Information
- **No Third-Party Dependencies:**  
  The project uses only Apple’s frameworks for all aspects, including networking, UI, image caching, and testing.
- **Future Improvements:**  
  Potential enhancements include integrating a detailed recipe view, supporting user favorites, and adding more granular caching controls.
- **System Requirements:**  
  Designed for iOS 16 and above.

