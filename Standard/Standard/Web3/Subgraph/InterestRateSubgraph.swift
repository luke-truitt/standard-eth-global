//
//  InterestRateSubgraph.swift
//  Standard
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation

public func calcAvgRate(completion: @escaping(Result<Double, Error>)->Void) {
    getHistory { result in
            switch result {
            case .success(let history):
                let blocks = getDayBlocks(history: history)
                let rate = calculateRate(block1: blocks[0], block2: blocks[1])
                completion(.success(rate))
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
        }
}
func getDayBlocks(history: [InterestRate])->[InterestRate] {
    let mostRecentBlock = history[0];
    let mostRecentTime = mostRecentBlock.timestamp;
    let oneDayAgo = mostRecentTime - 24*60*60;
    var j = history.count - 1;
    while(oneDayAgo > history[j].timestamp) {
        j = j - 1
    }
    let relevantTimes = [history[0], history[j]]
    return relevantTimes
}
func getHistory(completion: @escaping(Result<[InterestRate], Error>)->Void) {
    let num_blocks = 200
    let request = InterestRateRequest()
    var i = 0
    var rates = [InterestRate]()
    while(i < num_blocks) {
        
        request.getRates(skip_size: i) { result in
            switch result {
                case .success(let arr):
                    for item in arr {
                        let ii = item as! [String:Any]
                        let index = ii["liquidityIndex"] as! String
                        let time = (ii["timestamp"] as! NSNumber).stringValue
                        let rate = InterestRate(liquidityIndex: BigUInt(index) ?? 0, timestamp: BigUInt(time) ?? 0)
                        rates.append(rate)
                    }
                    i = i + 100
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
            sleep(1)
        }
    completion(.success(rates))
    }
    
func calculateRate(block1: InterestRate, block2: InterestRate)->Double {
    let SECONDS_PER_YEAR = 60*60*24*365.25
    let index_2 = Double(block2.liquidityIndex)
    let index_1 = Double(block1.liquidityIndex)
    let time_2 = Double(block2.timestamp)
    let time_1 = Double(block1.timestamp)
    let time_diff = (time_1 - time_2);
    let rate_ratio = (index_1/index_2);
    let time_ratio = rate_ratio/time_diff;
    return time_ratio * SECONDS_PER_YEAR/1000;
}

