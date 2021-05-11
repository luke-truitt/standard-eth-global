//
//  iosApp.swift
//  ios
//
//  Created by Work on 5/6/21.
//

//
//  iosApp.swift
//  ios
//
//  Created by Work on 5/6/21.
//
import SwiftUI
import web3
import BigInt

@main
struct iosApp: App {
//    let client : EthereumClient! = EthereumClient(url: URL(string: "https://rpc-mumbai.maticvigil.com/v1/bdf5efccf9de08ad6529de85ac5683ce47f0ffe5")!, sessionConfig: URLSessionConfiguration.default )
    let client : EthereumClient! = EthereumClient(url: URL(string: "https://kovan.infura.io/v3/700be78778b349229366a4a40b1d5df2")!, sessionConfig: URLSessionConfiguration.default )
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: initialize)
        }
    }
    
    func initialize() {
        calcAvgRate { result in
            switch result {
            case .success(let rate):
                print(rate)
            case .failure(let err):
                print(err)
            }
        }
//        let userAddress = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
//        let user2Address = EthereumAddress("0xCe697A0aF5dA8faB0C13Ba9640488fC8975a3f9B")
//        let userKey = "36cf2b7d4955842eee79b8c2692dc52c086c2d272c533f80973938c9df491b9f"
//        let contractAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
//        let tokenAddress = EthereumAddress("0xff795577d9ac8bd7d90ee22b6c1703490b6512fd")
//        var keyStorage = TestEthereumKeyStorage(privateKey: userKey)
//        var account = try! EthereumAccount(keyStorage: keyStorage)
//        account.address = userAddress
//        var keyStorage2 = EthereumKeyLocalStorage()
//        var account2 = try! EthereumAccount.create(keyStorage: keyStorage2, keystorePassword: "hello")
//        print(account2.address)
        
        
//    }
//}
//        client!.eth_gasPrice(completion: {(error, price) in
//            do {
//                let function = transfer(contract: tokenAddress, from: userAddress, to: account2.address, value: "300000000000000000000")
//                let transaction = try function.transaction()
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: transaction.from, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: price!, gasLimit: BigUInt(600000), chainId: 42)
//                print(tx)
//                print("big error \(error)")
//                client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                    print("error is \(bigError)")
//                    print("TX Hash: \(txHash)")
//
//            }
//        }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
//        })
            
//        client!.eth_gasPrice(completion: {(error, price) in
//            do {
//                let function = Withdraw(asset: tokenAddress, amount: BigUInt("995147905179352825856"), to: userAddress, gasPrice: price!, gasLimit: BigUInt(600000))
//                let transaction = try function.transaction()
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: userAddress, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
//                    print(tx)
//                    print("big error \(error)")
//                    client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                        print("error is \(bigError)")
//                        print("TX Hash: \(txHash)")
//
//                    }
//                }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
//            do {
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: userAddress, to: user2Address, value: 1000000000000000000, data: "0x0".data(using: .utf8), nonce: count, gasPrice: price!, gasLimit: BigUInt(600000), chainId: 42)
//                print(tx)
//                print("big error \(error)")
//                client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                    print("error is \(bigError)")
//                    print("TX Hash: \(txHash)")
//
//            }
//        }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
            
//            do {
//                let function = Deposit(asset: tokenAddress, amount: BigUInt("295147905179352825856"), onBehalfOf: userAddress, referralCode: UInt16(0), gasPrice: price!, gasLimit: BigUInt(600000))
//                let transaction = try function.transaction()
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: userAddress, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
//                    print(tx)
//                    print("big error \(error)")
//                    client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                        print("error is \(bigError)")
//                        print("TX Hash: \(txHash)")
//
//                    }
//                }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
            
//        })
    }
}
func calcAvgRate(completion: @escaping(Result<[InterestRate], Error>)->Void) {
    let num_blocks = 1800
    let request = InterestRateRequest()
    var i = 0
    let myGroup = DispatchGroup()
    var rates = [InterestRate]()
    while(i < num_blocks) {
        myGroup.enter()
        request.getRates(skip_size: i) { result in
            switch result {
                case .success(let arr):
                    for item in arr {
                        let ii = item as! [String:Any]
                        let rate = InterestRate(liquidityIndex: ii["liquidityIndex"] as! BigUInt, timestamp: ii["timestamp"] as! BigUInt)
                        rates.append(rate)
                    }
                    i = i + 100
                    myGroup.leave()
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                }
            }
        }
    completion(.success(rates))
    }
    
func calculateRate(block1: [String:Any], block2: [String:Any])->Double {
    let SECONDS_PER_YEAR = 60*60*24*365.25
    let index_2 = block2["liquidityIndex"] as! Double;
    let index_1 = block1["liquidityIndex"] as! Double;
    let time_2 = block2["timestamp"] as! Double;
    let time_1 = block1["timestamp"] as! Double;
    let time_diff = (time_2 - time_1);
    let rate_ratio = (index_2/index_1);
    let time_ratio = rate_ratio/time_diff;
    return time_ratio * SECONDS_PER_YEAR;
}

public struct Deposit: ABIFunction {
        public static let name = "deposit"
        public let contract: EthereumAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        public let from: EthereumAddress? = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
    
        public let asset: EthereumAddress
        public let amount: BigUInt //uint104
        public let onBehalfOf: EthereumAddress
        public let referralCode: UInt16

        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(asset)
            try encoder.encode(amount)
            try encoder.encode(onBehalfOf)
            try encoder.encode(referralCode)
        }
    }

public struct Withdraw: ABIFunction {
        public static let name = "withdraw"
        public let contract: EthereumAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        public let from: EthereumAddress? = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
    
        public let asset: EthereumAddress
        public let amount: BigUInt //uint104
        public let to: EthereumAddress

        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(asset)
            try encoder.encode(amount)
            try encoder.encode(to)
        }
    }

public struct transfer: ABIFunction {
        public static let name = "transfer"
        public let gasPrice: BigUInt? = nil
        public let gasLimit: BigUInt? = nil
        public var contract: EthereumAddress
        public let from: EthereumAddress?

        public let to: EthereumAddress
        public let value: BigUInt

        public init(contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    to: EthereumAddress,
                    value: BigUInt) {
            self.contract = contract
            self.from = from
            self.to = to
            self.value = value
        }

        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(value)
        }
    }

class TestEthereumKeyStorage: EthereumKeyStorageProtocol {
    private var privateKey: String
    
    init(privateKey: String) {self.privateKey = privateKey}
    
    func storePrivateKey(key: Data) throws -> Void {
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}

struct InterestRateResponse:Decodable {
    var response:InterestRates
}
struct InterestRates:Decodable {
    var interestRates:[InterestRate]
}
struct InterestRate:Decodable {
    var liquidityIndex:BigUInt
    var timestamp:BigUInt
}

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

final class InterestRateBody: Codable {
    var id: Int?
    var query:String
    
    init(query:String){
        self.query = query
    }
}
