//
//  Logger.swift
//  toonitooni
//
//  Created by buzz on 2021/05/12.
//

import Foundation

private func filename(_ path: String) -> String {
    guard let filename = path.split(separator: "/").last else { return path }
    return String(filename.prefix(upTo: filename.index(filename.endIndex, offsetBy: -6)))
}

private func functionName(_ function: String) -> String {
    guard let functionName = function.split(separator: "(").first else { return function }
    return String(functionName)
}

//MARK:- Log
public func debug<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
  #if DEBUG
    print("📣 [\(filename(file))]\(functionName(function))(\(line)): \(message)")
  #endif
}

