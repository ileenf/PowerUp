import SwiftUI

struct DietView: View {
    @State private var eatOutFrequency = ""
    @State private var veggieFrequency = ""
    @State private var foodCategory = 0
    let options = ["Protein", "Carbs", "Fat", "Fiber"]
    @State private var category = ""
    @State private var isButtonPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("How many times per week do you eat out?")
                    .font(.headline)
                TextField("Example: 3", text: $eatOutFrequency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("How many cups of vegetables do you eat a week?")
                    .font(.headline)
                TextField("Example: 2", text: $veggieFrequency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("What category of food do you want to eat more of?")
                    .font(.headline)
                Picker("Select an option", selection: $foodCategory) {
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: foodCategory) { newValue in
                    category = options[newValue]
                }
            }
            
            Spacer()

            Button(action: {
                            saveUserData()
                        }) {
                            Text("Save")
                        }
            
            NavigationLink(destination: ExerciseView()) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
//            .simultaneousGesture(TapGesture().onEnded(saveUserData))
            .padding()
            
//            NavigationLink(
//                            destination: ExerciseView(),
////                            isActive: $isButtonPressed,
//                            label: {
//                                Button(action: {
//                                    saveUserData()
//                                }, label: {
//                                    Text("Continueee")
//                                })
//                            }
//                        )
            
        }
        .padding()
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
