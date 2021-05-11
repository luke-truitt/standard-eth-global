//
//  InterestRateRequest.swift
//  
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

public struct InterestRateRequest {
    let resourceURL:URL
    
    init() {
        self.resourceURL = URL(string: "https://api.thegraph.com/subgraphs/name/aave/aave-v2-matic")!
    }
    
    func getRates(skip_size:Int, completion: @escaping(Result<NSArray, APIError>)->Void) {
        do {
            let queryString = "{reserve(id: \"0xc2132d05d31c914a87c6611c10748aeb04b58e8f0xd05e3e715d945b59290df0ae8ef85c1bdb684744\") { id name paramsHistory(first: 100, skip: \(skip_size), orderDirection: desc, orderBy: timestamp) { id variableBorrowRate utilizationRate liquidityRate liquidityIndex timestamp } } }"
            let queryBody = InterestRateBody(query: queryString)
            var urlRequest = URLRequest(url: self.resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField:"Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(queryBody)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                do {
                    if let result = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String:Any] { if let data = result["data"] as? [String:Any] {
                        if let reserve = data["reserve"] as? [String:Any] {
                            if let paramsHistory = reserve["paramsHistory"] as? NSArray {
//                                for dict in paramHistory {
//                                    var d = dict as? [String:Any]
//                                      // Condition required to check for type safety :)
//                                    guard let liquidityIndex = dict["liquidityIndex"] as? BigUInt,
//                                              let liquidityRate = dict["liquidityRate"] as? BigUInt,
//                                              let timestamp = dict["timestamp"] as? BigUInt,
//                                              let utilizationRate = dict["utilizationRate"] as? BigUInt,
//                                              let variableBorrowRate = dict["variableBorrowRate"] as? BigUInt else {
//                                              print("Something is not well")
//                                             continue
//                                         }
//                                        let object = InterestRate(liquidityIndex: liquidityIndex, liquidityRate: liquidityRate, timestamp: timestamp, utilizationRate: utilizationRate, variableBorrowRate: variableBorrowRate)
//                                         arr.append(object)
//                                    }
                                completion(.success(paramsHistory))
                            }
                        }
                    }
                    }
//                    let messageData = try JSONDecoder().decode(, from:jsonData)
//                    completion(.success(messageData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            
            
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
        
    }
    
}
