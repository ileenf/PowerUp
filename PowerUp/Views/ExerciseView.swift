import SwiftUI

struct ExerciseView: View {
    @State private var workoutFrequency = ""
    @State private var selectedTypeOption = 0
    let workoutTypeOptions = ["Active", "Casual", "Leisure"]
    @State private var workoutType = ""
    
    @State private var selectedPartOption = 0
    let bodyPartOptions = ["Arms", "Cardio", "Core", "Legs", "Flexibility"]
    @State private var bodyPartType = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("How many days per week do you work out?")
                    .font(.headline)
                TextField("Example: 3", text: $workoutFrequency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("What kind of active level would you describe your workouts?")
                    .font(.headline)
                Picker("Select an option", selection: $selectedTypeOption) {
                    ForEach(0..<workoutTypeOptions.count) { index in
                        Text(workoutTypeOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedTypeOption) { newValue in
                    workoutType = workoutTypeOptions[newValue]
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("What specific part of your body do you want to workout?")
                    .font(.headline)
                Picker("Select an option", selection: $selectedPartOption) {
                    ForEach(0..<bodyPartOptions.count) { index in
                        Text(bodyPartOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedPartOption) { newValue in
                    bodyPartType = bodyPartOptions[newValue]
                }
            }
            Spacer()
            
            NavigationLink(destination: ResultsView()) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
        }
        .padding()
    }
}
