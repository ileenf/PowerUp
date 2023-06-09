//
//  WelcomeView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome power ranger!!!")
                    .font(.title)
                    .padding()
                
                Image("rangers").resizable().scaledToFit()
                
                NavigationLink(destination: ProfileView()) {
                    Text("Let's get started!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("PowerUp")
        }
    }
}
