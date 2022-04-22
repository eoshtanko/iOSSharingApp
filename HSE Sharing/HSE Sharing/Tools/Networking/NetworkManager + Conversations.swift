//
//  NetworkManager + Conversations.swift
//  HSE Sharing
//
//  Created by Екатерина on 22.04.2022.
//

import Foundation

extension Api {
    
    func createConversation(conversation: Conversation, _ completion: @escaping (Result<Conversation>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Chats")!
        var request = createRequest(url: url, httpMethod: .POST)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: conversation.toDict, options: .prettyPrinted)
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
            guard let result = try? self.decoder.decode(Conversation.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func deleteConversation(id: Int, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Chats/\(id)")!
        let request = createRequest(url: url, httpMethod: .DELETE)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func getConversations(email: String, _ completion: @escaping (Result<[Conversation]>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Chats/\(email)/user")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode([Conversation].self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
}
