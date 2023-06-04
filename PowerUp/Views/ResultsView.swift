//
//  WelcomeView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI

//struct Food: Codable {
//    let Category: String
//    let Data: [String: Any]
//    let Description: String
//    let NutrientDataBankNumber: Int
//
//    enum CodingKeys: String, CodingKey {
//        case Category
//        case Data
//        case Description
//        case NutrientDataBankNumber
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        Category = try container.decode(String.self, forKey: .Category)
//        Description = try container.decode(String.self, forKey: .Description)
//        NutrientDataBankNumber = try container.decode(Int.self, forKey: .NutrientDataBankNumber)
//        Data = try container.decode([String: AnyCodable].self, forKey: .Data).compactMapValues { $0.value }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(Category, forKey: .Category)
//        try container.encode(Description, forKey: .Description)
//        try container.encode(NutrientDataBankNumber, forKey: .NutrientDataBankNumber)
//        try container.encode(Data.mapValues(AnyCodable.init), forKey: .Data)
//    }
//}
//
//struct AnyCodable: Codable {
//    let value: Any
//
//    init(_ value: Any) {
//        self.value = value
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let int = try? container.decode(Int.self) {
//            value = int
//        } else if let double = try? container.decode(Double.self) {
//            value = double
//        } else if let string = try? container.decode(String.self) {
//            value = string
//        } else if let bool = try? container.decode(Bool.self) {
//            value = bool
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch value {
//        case let int as Int:
//            try container.encode(int)
//        case let double as Double:
//            try container.encode(double)
//        case let string as String:
//            try container.encode(string)
//        case let bool as Bool:
//            try container.encode(bool)
//        default:
//            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported type"))
//        }
//    }
//}



struct ResultsView: View {
    let firstName: String = UserDefaults.standard.string(forKey: "firstName")!
    
    var body: some View {
        NavigationView {
            VStack {
                Text("The results are in...")
                    .font(.title)
                    .padding()
                    .onAppear(perform: requestData)

                NavigationLink(destination: HealthStatsView()) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                
                Text(firstName)
                    .font(.title)
            }
            .navigationBarTitle("PowerUp")
        }
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
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
//                let decoder = JSONDecoder()
//                do {
//                    let foods = try decoder.decode([Food].self, from: data)
//
//                    // Access and work with the parsed data
//                    for food in foods {
//                        print("Category: \(food.Category)")
//                        print("Description: \(food.Description)")
//                        print("Nutrient Data Bank Number: \(food.NutrientDataBankNumber)")
//                        print("Data: \(food.Data)")
//                        print("--------")
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }
            }
        }
        task.resume()

    }
}

