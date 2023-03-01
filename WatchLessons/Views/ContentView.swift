//
//  ContentView.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
