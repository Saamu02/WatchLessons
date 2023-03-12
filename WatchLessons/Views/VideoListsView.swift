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
                    
                    NavigationLink (destination: DetailViewControllerRepresentable(lessonList: lessonsViewModel.lessons, currrentLesson: lesson).navigationBarTitleDisplayMode(.inline) ) {
                        
                        HStack {

                            AsyncImage(url: URL(string: lesson.thumbnail)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)

                            } placeholder: {
                                ProgressView()
                            }
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
                title: Text("Alert!"),
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
