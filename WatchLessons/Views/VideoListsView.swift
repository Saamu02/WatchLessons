//
//  ContentView.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import SwiftUI

struct VideoListsView: View {
    
    @ObservedObject var lessonsViewModel = LessonsListsViewModel()
    
    var body: some View {
        
        ZStack {

            NavigationView {

                List(lessonsViewModel.lessons) { lesson in
                    
                    NavigationLink (destination: DetailViewControllerRepresentable(videoURL: lesson.videoUrl).navigationBarTitleDisplayMode(.inline) ) {
                        
                        HStack {
                            Image("test")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                            Text(String(lesson.name))
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitle("Lessons")
            }
            
            ProgressView("Fetching Data")
                .isHidden(!self.lessonsViewModel.fetchingData)
                .foregroundColor(.white)
        }
        .onAppear {
            self.lessonsViewModel.fetchLesson()
            AppDelegate.orientationLock = .portrait
        }
        .alert(isPresented: self.$lessonsViewModel.showError) {
            Alert (
                title: Text("Network error"),
                message: Text(self.lessonsViewModel.errorDescription),
                dismissButton: .cancel()
            )
        }
        .onDisappear() {
            AppDelegate.orientationLock = .all
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        VideoListsView()
    }
}
