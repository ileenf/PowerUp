import SwiftUI

struct WelcomeBackView: View {
    @State private var firstName: String = ""
    @State private var overallScore: Int = 0
    
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
                            .font(.custom("Verdana", size: 50))
                            .foregroundColor(lightWhite)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Spacer()
                        
                        Text("Your current overall score is \(overallScore) / 1000")
                            .font(.custom("Verdana", size: 30))
                            .foregroundColor(lightPink)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            
                        Spacer()
                        
                        NavigationLink(destination: ResultsView()) {
                            Text("Recommendations")
                                .font(.custom("Verdana", size: 20))
                                .foregroundColor(baseBlack)
                                .padding()
                                .background(lightPink)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: DietView()) {
                            Text("Edit Info")
                                .font(.custom("Verdana", size: 20))
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
        overallScore = UserDefaults.standard.integer(forKey: "overallScore") ?? 0
    }
}
