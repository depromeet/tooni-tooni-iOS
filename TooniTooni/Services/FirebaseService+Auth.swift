//
//  FirebaseService+Auth.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/31.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthable {

  func signInAnonymously(completion: @escaping (User) -> Void)
}

extension FirebaseService: FirebaseAuthable {

  func signInAnonymously(completion: @escaping (User) -> Void) {
    Auth.auth().signInAnonymously { result, error in
      if let error = error {
        debug(error)
        return
      }

      guard let user = result?.user else { return }
      completion(user)
    }
  }
}
