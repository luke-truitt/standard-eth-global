//
//  AppDelegate+Injection.swift
//  
//
//  Created by Work on 5/10/21.
//

import Foundation
import Resolver
import FirebaseFunctions
import FirebaseFirestore

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
//    register { AuthenticationService() }.scope(application)
    register { FirestoreWalletRepository() as WalletRepository }.scope(application)
  }
}

extension Functions {
    func useEmulator() -> Functions {
        #if USE_FIREBASE_EMULATORS
        print("Using the Firebase Emulator for Cloud Functions, running on port 5001")
        self.useFunctionsEmulator(origin: "https://localhost:5001")
        #else
        print("Using Cloud Functions in production")
        #endif
        return self
    }
}

extension Firestore {
    func useEmulator() -> Firestore {
        #if USE_FIREBASE_EMULATORS
        print("Using the Firebase Emulator for Cloud Firestore, running on port 8080")
        let settings = self.settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        self.settings = settings
        #else
        print("Using Cloud Firestore in production")
        #endif
        return self
    }
}
