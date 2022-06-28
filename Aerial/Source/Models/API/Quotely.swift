// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct QuotelyData: Codable {
    let quotes: [Quote]
    let userID: String

    enum CodingKeys: String, CodingKey {
        case quotes
        case userID = "userId"
    }
}
// MARK: - Quote
struct Quote: Codable {
    let title, body, id: String
}

struct Quotely {
    static func fetch(completion: @escaping(Result<QuotelyData, NetworkError>) -> Void) {
//        if PrefsInfo.quote.url.isEmpty {
//            return
//        }
        
        let url = "https://upg7zzj622.execute-api.us-west-2.amazonaws.com/api/quotes/vueringschristian@gmail.com"

        fetchData(from: url) { result in
            switch result {
            case .success(let jsonString):
                let jsonData = jsonString.data(using: .utf8)!

                if let quotes = try? newJSONDecoder().decode(QuotelyData.self, from: jsonData) {
                    completion(.success(quotes))
                } else if (try? newJSONDecoder().decode(ForecastError.self, from: jsonData)) != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            case .failure(let error):
                completion(.failure(.unknown))
                print(error.localizedDescription)
            }
        }
    }
    
    private static func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}
