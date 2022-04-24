//
//  NetworkManager + Feedbacks.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.04.2022.
//

import Foundation

extension Api {
    func createFeedback(feedback: Feedback, _ completion: @escaping (Result<Feedback>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Feedbacks")!
        var request = createRequest(url: url, httpMethod: .POST)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: feedback.toDict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                }
                completion(Result.failure(ApiError.badResponse))
                return
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode(Feedback.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func deleteFeetback(id: Int64, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Feedbacks/\(id)")!
        let request = createRequest(url: url, httpMethod: .DELETE)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                }
                completion(Result.failure(ApiError.badResponse))
                return
            }
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func getFeetbacksOfSpecificUser(email: String, _ completion: @escaping (Result<[Feedback]>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)/feedbacks")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        if let response = response as? HTTPURLResponse {
                            print(response.statusCode)
                        }
                completion(Result.failure(ApiError.badResponse))
                return
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode([Feedback].self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
}
