//
//  URLValidator.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import Foundation

protocol URLValidating {
  func validate(_ text: String) -> URL?
}

struct URLValidator: URLValidating {
  
  func validate(_ text: String) -> URL? {
    let normalizedText = normalize(text)
    
    guard let components = URLComponents(string: normalizedText),
          let scheme = components.scheme?.lowercased(),
          ["http", "https"].contains(scheme),
          let host = components.host,
          !host.isEmpty
    else {
      return nil
    }
    
    return components.url
  }
  
  private func normalize(_ text: String) -> String {
    var text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !text.isEmpty else {
      return text
    }
    
    if !text.lowercased().hasPrefix("http://"),
       !text.lowercased().hasPrefix("https://") {
      text = "https://" + text
    }
    
    return text
  }
}
