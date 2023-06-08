import SwiftUI

struct ExerciseView: View {
    @State private var workoutFrequency = ""
    @State private var selectedTypeOption = 0
    let workoutTypeOptions = ["Leisure", "Casual", "Active"]
    @State private var workoutType = ""
    
    @State private var selectedPartOption = 0
    let bodyPartOptions = ["Arms", "Cardio", "Core", "Legs", "Flexibility"]
    @State private var bodyPartType = ""
    
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)
    
    let eatOutFrequency: String = UserDefaults.standard.string(forKey: "eatOutFrequency") ?? "no value"
    
    var body: some View {
        baseBlack
            .ignoresSafeArea() // Ignore just for the color
            .overlay(
                VStack(spacing: 20) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How many days per week do you work out?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        TextField("Example: 3", text: $workoutFrequency)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.headline)
                            .foregroundColor(baseBlack)
                            .background(lightWhite)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What kind of active level would you describe your workouts?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        Picker("Select an option", selection: $selectedTypeOption) {
                            ForEach(0..<workoutTypeOptions.count) { index in
                                Text(workoutTypeOptions[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedTypeOption) { newValue in
                            workoutType = workoutTypeOptions[newValue]
                        }
                        .background(lightPink)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What specific part of your body do you want to workout?")
                            .font(.title)
                            .foregroundColor(lightPink)
                        Picker("Select an option", selection: $selectedPartOption) {
                            ForEach(0..<bodyPartOptions.count) { index in
                                Text(bodyPartOptions[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedPartOption) { newValue in
                            bodyPartType = bodyPartOptions[newValue]
                        }
                        .background(lightPink)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ResultsView()) {
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
        print(eatOutFrequency)
        print("FRQUENCY")
        print(workoutFrequency)
        UserDefaults.standard.set(workoutFrequency, forKey: "workoutFrequency")
        UserDefaults.standard.set(workoutTypeOptions[selectedTypeOption], forKey: "selectedTypeOption")
        UserDefaults.standard.set(bodyPartOptions[selectedPartOption], forKey: "selectedPartOption")
                
        print("Saved data from Exercise View")
    }
}
