//
//  InterestRateRequest.swift
//  
//
//  Created by Luke Truitt on 5/10/21.
//

import Foundation
import InterestRate

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

public struct InterestRateRequest {
    let resourceURL:URL
    
    init() {
        self.resourceURL = URL('https://api.thegraph.com/subgraphs/name/aave/aave-v2-matic')
    }
    
    public getRates(skip_size:Int)->InterestRateResponse {
        do {
            let queryString = '{reserve(id: \"0xc2132d05d31c914a87c6611c10748aeb04b58e8f0xd05e3e715d945b59290df0ae8ef85c1bdb684744\") { id name paramsHistory(first: 100, skip: \(skip_size), orderDirection: desc, orderBy: timestamp) { id variableBorrowRate utilizationRate liquidityRate liquidityIndex timestamp } } }'
            let queryBody = InterestRateBody(queryString)
            var urlRequeset = URLRequest(url: self.resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHttpHeaderField:"Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(queryBody)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else {
                    completion(.failure(.responseProblem))
                }
                
            }
            
            do {
                let messageData = try JSONDecoder().decode(InterstRates.self, from:jsonData)
                completion(.success(messageData))
            } catch {
                completion(.failure(.decodingProblem))
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
        
    }
    
}
