//
//  ContentView.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    let posts = [ Post(id: "0", name: "Ussama"), Post(id: "1", name: "Irfan")]
    
    var body: some View {
        NavigationView {

            List(posts) { post in
                NavigationLink (destination: DetailViewControllerRepresentable().navigationBarTitleDisplayMode(.inline) ) {
                    HStack {
                        Image("test")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                        Text("The Key To Success In iPhone Photogrophy")
                    }
                }
            }
            .listStyle(.plain)
            
            .navigationBarTitle("Lessons")
        }
        .onAppear {
//            self.networkManager.fetchData()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Post: Identifiable {
    var id: String
    var name: String
}
