//
//  WelcomeView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI

struct WelcomeView: View {
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)
    
    var body: some View {
             NavigationView {
                baseBlack.ignoresSafeArea().overlay(
                    VStack {
                        Text("PowerUp")
                            .font(.title)
                            .bold()
                            .foregroundColor(lightWhite)
                            .padding()
                        
                        Image("sunset").resizable()
                        
                        NavigationLink(destination: ProfileView()) {
                            Text("Let's get started!")
                                .font(.headline)
                                .foregroundColor(baseBlack)
                                .padding()
                                .background(lightPink)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
//                    .navigationBarTitle("PowerUp")
//                    .foregroundColor(Color.white)
//                    .background(Color.white)
                    .scaledToFill()
                )
             }
        }
}

extension Color {
    init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
}
