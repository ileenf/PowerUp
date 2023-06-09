import SwiftUI

struct WelcomeBackView: View {
    @State private var firstName: String = ""
    
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)
    
    var body: some View {
        NavigationView {
            baseBlack
                .ignoresSafeArea() // Ignore just for the color
                .overlay(
                    VStack {
                        Text("Welcome back \(firstName)!")
        //                        .textFieldStyle(PlainTextFieldStyle())
        //                        .padding()
                            .font(.title)
                            .foregroundColor(baseBlack)
        //                        .accentColor(lightWhite)
                            .background(lightWhite)
                            .cornerRadius(8)
                            .shadow(radius: 4)

                        
                        NavigationLink(destination: ResultsView()) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(baseBlack)
                                .padding()
                                .background(lightPink)
                                .cornerRadius(10)
                        }
                    }
                    .background(baseBlack.opacity(0.1))
                    .onAppear(perform: {
                        retrieveUserData()
                    })
               )
        }
    }
    private func retrieveUserData() {
        firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
    }
}
