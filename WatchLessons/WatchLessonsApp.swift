//
//  WatchLessonsApp.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import SwiftUI

@main
struct WatchLessonsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            VideoListsView()
        }
    }
}
