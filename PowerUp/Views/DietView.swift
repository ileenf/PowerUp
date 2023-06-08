import SwiftUI

struct DietView: View {
    @State private var eatOutFrequency = ""
    @State private var veggieFrequency = ""
    @State private var foodCategory = 0
    let options = ["Protein", "Carbs", "Fat", "Fiber"]
    @State private var category = ""
    @State private var isButtonPressed = false
    
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)

    var body: some View {
        baseBlack
            .ignoresSafeArea() // Ignore just for the color
            .overlay(
                VStack(spacing: 50) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("How many times per week do you eat out?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        TextField("Example: 3", text: $eatOutFrequency)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.headline)
                            .foregroundColor(baseBlack)
                            .background(lightPink)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("How many cups of vegetables do you eat a week?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        TextField("Example: 2", text: $veggieFrequency)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.headline)
                            .foregroundColor(baseBlack)
                            .background(lightPink)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("What category of food do you want to eat more of?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        Picker("Select an option", selection: $foodCategory) {
                            ForEach(0..<options.count) { index in
                                Text(options[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: foodCategory) { newValue in
                            category = options[newValue]
                        }
                        .foregroundColor(lightWhite)
                        .background(lightPink)
                    }
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(baseBlack)
                            .padding()
                            .background(lightPink)
                            .cornerRadius(10)
                    }
                    .simultaneousGesture(TapGesture().onEnded(saveUserData))
                    .padding()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            )
    }
    
    func saveUserData() {
        // saves data on local storage
        UserDefaults.standard.set(eatOutFrequency, forKey: "eatOutFrequency")
        UserDefaults.standard.set(veggieFrequency, forKey: "veggieFrequency")
        UserDefaults.standard.set(options[foodCategory], forKey: "foodCategory")
        print("Saved data from DietView")
        isButtonPressed = true;
    }
}
