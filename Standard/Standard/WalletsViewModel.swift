////
////  WalletViewModel.swift
////  Standard
////
////  Created by Work on 5/10/21.
////
//
//import Foundation
//import Foundation
//import Resolver
//import Combine
//
//class WalletViewModel: ObservableObject {
//    @Injected var walletRepository: WalletRepository
//    @Published var wallet: Wallet
//    
//    var id: String = ""
//    @Published var completionStateIconName = ""
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    static func newWallet() -> WalletViewModel {
//      WalletViewModel(task: Task(title: "", priority: .medium, completed: false))
//    }
//    
//    init(task: Task) {
//      self.task = task
//      
//      $task
//        .map { $0.completed ? "checkmark.circle.fill" : "circle" }
//        .assign(to: \.completionStateIconName, on: self)
//        .store(in: &cancellables)
//
//      $task
//        .compactMap { $0.id }
//        .assign(to: \.id, on: self)
//        .store(in: &cancellables)
//      
//      $task
//        .dropFirst()
//        .debounce(for: 0.8, scheduler: RunLoop.main)
//        .sink { [weak self] task in
//          self?.taskRepository.updateTask(task)
//        }
//        .store(in: &cancellables)
//    }
//    
//  }
