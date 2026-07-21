//
//  URLItem.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import Foundation

struct URLItem: Hashable, Codable {
  let id: UUID
  let url: URL
  
  init(id: UUID = UUID(), url: URL) {
    self.id = id
    self.url = url
  }
}
