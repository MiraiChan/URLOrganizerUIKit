//
//  URLRepository.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import Foundation

protocol URLRepositoryProtocol {
  var urls: [URLItem] { get }
  
  func load() async throws
  
  func add(_ url: URL) throws
  func remove(_ item: URLItem) throws
  func removeAll() throws
  func removeDuplicates(of item: URLItem) throws
}

final class URLRepository: URLRepositoryProtocol {
  
  private let storage: StorageServiceProtocol
  private(set) var urls: [URLItem] = []
  
  init(storage: StorageServiceProtocol = FileManagerStorageService()) {
    self.storage = storage
  }
  
  func load() async throws {
    urls = try await storage.loadData()
  }
  
  func add(_ url: URL) throws {
    urls.append(URLItem(url: url))
    try storage.saveData(urls)
  }
  
  func remove(_ item: URLItem) throws {
    urls.removeAll { $0.id == item.id }
    try storage.saveData(urls)
  }
  
  func removeAll() throws {
    urls.removeAll()
    try storage.saveData(urls)
  }
  
  func removeDuplicates(of item: URLItem) throws {
    if let firstIndex = urls.firstIndex(where: { $0.url == item.url }) {
      let firstItem = urls[firstIndex]
      urls.removeAll { $0.url == item.url && $0.id != firstItem.id }
      try storage.saveData(urls)
    }
  }
}

