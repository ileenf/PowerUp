import SwiftUI

struct ResultsView: View {
    @State private var firstName: String = ""
    @State private var eatOutFrequency: String = ""
    @State private var veggieFrequency: String = ""
    @State private var foodCategory: String = ""
    @State private var workoutFrequency: String = ""
    @State private var bodyPart: String = ""
    @State private var activityLevel: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("The results are in...")
                    .font(.title)
                    .padding()
                    .onAppear(perform: requestData)

                Text("eatOutFrequency: \(eatOutFrequency)")
                    .padding()
                Text("veggieFrequency: \(veggieFrequency)")
                    .padding()
                Text("foodCategory: \(foodCategory)")
                    .padding()
                Text("workoutFrequency: \(workoutFrequency)")
                    .padding()
                Text("activityLevel: \(activityLevel)")
                    .padding()
                Text("bodyPart: \(bodyPart)")
                    .padding()
                Text(firstName)
                    .font(.title)
            }
            .navigationBarTitle("PowerUp")
        }
        .onAppear(perform: retrieveUserData)
    }

    private func retrieveUserData() {
        firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        eatOutFrequency = UserDefaults.standard.string(forKey: "eatOutFrequency") ?? ""
        veggieFrequency = UserDefaults.standard.string(forKey: "veggieFrequency") ?? ""
        foodCategory = UserDefaults.standard.string(forKey: "foodCategory") ?? ""
        workoutFrequency = UserDefaults.standard.string(forKey: "workoutFrequency") ?? ""
        bodyPart = UserDefaults.standard.string(forKey: "selectedPartOption") ?? ""
        activityLevel = UserDefaults.standard.string(forKey: "selectedTypeOption") ?? ""
    }

    private func requestData(){

        let category = "calories"
        let minVal = "100"
        let maxVal = "300"
        let urlString = "https://power-up-backend.vercel.app/api/foods/\(category)?min=\(minVal)&max=\(maxVal)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

            if let data = data {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Response: \(responseString)")
//                }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for json in jsonArray {
                            if let category = json["Category"] as? String,
//                               let data = json["Data"] as? [String: Any],
                               let description = json["Description"] as? String,
                               let nutrientDataBankNumber = json["Nutrient Data Bank Number"] as? Int {

                                // Use the extracted values here
                                print("Category: \(category)")
//                                print("Data: \(data)")
                                print("Description: \(description)")
                                print("Nutrient Data Bank Number: \(nutrientDataBankNumber)")
                                print()
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()

    }
}
