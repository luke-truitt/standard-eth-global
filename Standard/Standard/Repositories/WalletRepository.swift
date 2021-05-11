//
//  WalletRepositoruy.swift
//  
//
//  Created by Work on 5/10/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions

import Resolver


class BaseWalletRepository {
  @Published var wallets = [Wallet]()
}

protocol WalletRepository: BaseWalletRepository {
    func addWallet(_ wallet: Wallet)
    func removeWallet(_ wallet: Wallet)
    func updateWallet(_ wallet: Wallet)
}

class FirestoreWalletRepository: BaseWalletRepository, WalletRepository, ObservableObject {
    var db = Firestore.firestore()
    
    override init() {
        super.init()
        loadData()
    }
    
    private func loadData() {
        db.collection("wallets").order(by: "createdTime").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.wallets = querySnapshot.documents.compactMap { document -> Wallet? in
                    try? document.data(as: Wallet.self)
                }
            }
        }
    }
    
    func addWallet(_ wallet: Wallet) {
        do {
          let _ = try db.collection("wallets").addDocument(from: wallet)
        }
        catch {
          print("There was an error while trying to save a user \(error.localizedDescription).")
        }
      }
    
    func updateWallet(_ wallet: Wallet) {
        if let walletID = wallet.id {
          do {
            try db.collection("wallets").document(walletID).setData(from: wallet) // (1)
          }
          catch {
            print("There was an error while trying to update a user \(error.localizedDescription).")
          }
        }
      }
    
    func removeWallet(_ wallet: Wallet) {
        if let walletID = wallet.id {
          db.collection("wallets").document(walletID).delete { (error) in // (1)
            if let error = error {
              print("Error removing document: \(error.localizedDescription)")
            }
          }
        }
      }
}
