import SwiftUI

struct DietView: View {
    var calories: Int
    @State private var eatOutFrequency = ""
    @State private var veggieFrequency = ""
    @State private var selectedOption = 0
    let options = ["Protein", "Carbs", "Fat", "Fiber"]
    @State private var category = ""
    
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
                Picker("Select an option", selection: $selectedOption) {
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedOption) { newValue in
                    category = options[newValue]
                }
            }
            
            Text("Calories: \(calories) cal")
                .font(.title)
            
            Spacer()
        }
        .padding()
    }
}
