//
//  NetworkManager + Skills.swift
//  HSE Sharing
//
//  Created by Екатерина on 12.04.2022.
//

import Foundation

extension Api {
    
    func createSkill(skill: Skill, _ completion: @escaping (Result<Skill>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Skills")!
        var request = createRequest(url: url, httpMethod: .POST)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: skill.toDict, options: .prettyPrinted)
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
            guard let result = try? self.decoder.decode(Skill.self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            CurrentUser.user.skills?.append(result)
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func editSkill(skill: Skill, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Skills/\(skill.id)")!
        var request = createRequest(url: url, httpMethod: .PUT)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: skill.toDict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            if let skills = CurrentUser.user.skills {
                for i in 0..<skills.count {
                    if skills[i].id == skill.id {
                        CurrentUser.user.skills![i] = skill
                        break
                    }
                }
            }
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func deleteSkill(id: Int64, _ completion: @escaping (Result<Any>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Skills/\(id)")!
        let request = createRequest(url: url, httpMethod: .DELETE)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(ApiError.badResponse))
                return
            }
            CurrentUser.user.skills!.removeAll(where: { $0.id == id })
            return completion(Result.success(""))
        })
        task.resume()
    }
    
    func getSkillsOfSpecificUser(email: String, _ completion: @escaping (Result<[Skill]>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Skills/\(email)/skills")!
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
            guard let result = try? self.decoder.decode([Skill].self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func getSkills(_ completion: @escaping (Result<[Skill]>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(CurrentUser.user.mail!)/skills")!
        let request = createRequest(url: url, httpMethod: .GET)
        
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
            guard let result = try? self.decoder.decode([Skill].self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
    
    func getSkillsByParametrs(params: SearchParametrs, _ completion: @escaping (Result<[Skill]>) -> Void) {
        let session = createSession()
        let url = URL(string: "\(baseURL)/api/Users/\(CurrentUser.user.mail!)/skills?studyingYearID=\(params.studyingYearID)&majorID=\(params.majorID)&campusLocationID=\(params.campusLocationID)&dormitoryID=\(params.dormitoryID)&gender=\(params.gender)&skillstatus=\(params.skillstatus)&category=\(params.category)&subcategory=\(params.subcategory)")!
        let request = createRequest(url: url, httpMethod: .GET)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
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
            guard let result = try? self.decoder.decode([Skill].self, from: jsonData) else {
                return completion(Result.failure(ApiError.couldNotParse))
            }
            return completion(Result.success(result))
        })
        task.resume()
    }
}
