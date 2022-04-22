//
//  NetworkManager + User.swift
//  HSE Sharing
//
//  Created by Екатерина on 11.04.2022.
//

import Foundation

extension Api {
    
    func createUser(email: String, _ completion: @escaping (Result<User>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/")!
        var request = createRequest(url: url, httpMethod: .POST)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["mail" : email, "password": "1234567"], options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.description)
                }
                completion(Result.failure(ApiError.badResponse))
                return
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode(User.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            CurrentUser.user = result
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func getUserByEmail(email: String, _ completion: @escaping (Result<User>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) || response.statusCode == 404  else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            if response.statusCode == 404 {
                return completion(Result.failure(ApiError.noSuchData))
            }
            guard let safeData = data else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            let jsonData = Data(safeData)
            guard let result = try? self.decoder.decode(User.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func editUser(email: String, user: User, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)")!
        var request = createRequest(url: url, httpMethod: .PUT)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: user.toDict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.description)
                }
                completion(Result.failure(ApiError.badResponse))
                return
            }
            CurrentUser.user = user
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func recoveryUsersPassword(email: String, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)/password")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) || response.statusCode == 400 else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            if response.statusCode == 400 {
                completion(Result.failure(ApiError.noSuchData))
            }
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func deleteUser(email: String, completion: @escaping () -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(email)")!
        let request = createRequest(url: url, httpMethod: .DELETE)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Oops!! there is server error!")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("The Response is : ",json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}
