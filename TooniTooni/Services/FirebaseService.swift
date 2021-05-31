//
//  FirebaseService.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/31.
//

import Foundation
import Firebase

class FirebaseService {

  static let shared = FirebaseService()

  func configure() {
    FirebaseApp.configure()
  }
}
