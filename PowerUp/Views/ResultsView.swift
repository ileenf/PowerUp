//
//  WelcomeView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI

struct ResultsView: View {
    let firstName: String = UserDefaults.standard.string(forKey: "firstName")!
    let eatOutFrequency: String = UserDefaults.standard.string(forKey: "eatOutFrequency")!
    let veggieFrequency: String = UserDefaults.standard.string(forKey: "veggieFrequency")!
    let foodCategory: String = UserDefaults.standard.string(forKey: "foodCategory")!
    let workoutFrequency: String = UserDefaults.standard.string(forKey: "workoutFrequency") ?? "No workout found"
    let bodyPart: String = UserDefaults.standard.string(forKey: "selectedPartOption") ?? "No activity part selected"
    let activityLevel: String = UserDefaults.standard.string(forKey: "selectedTypeOption") ?? "no body part"
    
    
    
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
                
                

//                NavigationLink(destination: ProfileView()) {
//                    Text("Continue")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
                .padding()
                
                
                Text(firstName)
                    .font(.title)
            }
            .navigationBarTitle("PowerUp")
        }
    }
    
    private func requestScoreData() {
        
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
