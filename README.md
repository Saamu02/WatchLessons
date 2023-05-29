# WatchLessons

This project was the assessment test for iPhone Photogrophy School


Here're the requirements for the test

## 👀  Assignment

Create a tiny app from scratch where users can pick a lesson from a list and watch it in the details view. 

Also they have to be able to download and watch the lesson when there's no internet connection.

### Tools:
🔨  Xcode

🔨  CocoaPods or Swift package manager

🔨  Combine

### 📱 Views

Lessons list screen:

- Show title “Lessons”
- Implement the lesson list screen using SwiftUI
- Show a thumbnail image and name for each lesson
- List of lessons has to be fetched when opening the application (from URL or local cache when no connection)

Lesson details screen:

- Implement the lessons details screen programmatically using UIKit
- Show video player
- Show a “Download” button to start download for offline viewing
- Show a “Cancel download” and progress bar when video is downloading
- Show lesson title
- Show lesson description
- Show a “Next lesson” button to play next lesson from the list

### 📎 Additional details

- Develop the application using:
    - Xcode
    - CocoaPods or Swift package manager
    - Combine
- Try to use as few 3rd party libraries as possible.
- The application has to work offline with a cached list of the lessons.
- The API endpoint to fetch the list of lessons is
    - https://iphonephotographyschool.com/test-api/lessons
- Show video in full screen when app rotates to landscape

### 📝 Testing

Write unit and UI automated tests with XCTest. 

Tests have to be meaningful and comprehensive and cover all important functionality of the app.

