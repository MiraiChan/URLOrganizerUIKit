//
//  URLListViewModel.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import Foundation

final class URLListViewModel {
  
  var onURLsChanged: (([URLItem]) -> Void)?
  var onError: ((String) -> Void)?
  var onOpenURL: ((URL) -> Void)?
  
  private let validator: URLValidating
  private let repository: URLRepositoryProtocol
  
  init(
    validator: URLValidating = URLValidator(),
    repository: URLRepositoryProtocol = URLRepository()
  ) {
    self.validator = validator
    self.repository = repository
  }
  
  var urls: [URLItem] {
    repository.urls
  }
  
  func loadURLs() async {
    do {
      try await repository.load()
      notifyURLsChanged()
    } catch {
      notifyURLsChanged()
    }
  }
  
  func addURL(from text: String) {
    guard let url = validator.validate(text) else {
      onError?("Please enter a valid web address starting with http:// or https://.")
      return
    }
    
    do {
      try repository.add(url)
      notifyURLsChanged()
    } catch {
      onError?("Failed to save URL. Please try again.")
    }
  }
  
  func remove(_ item: URLItem) {
    do {
      try repository.remove(item)
      notifyURLsChanged()
    } catch {
      onError?("Failed to remove URL. Please try again.")
    }
  }
  
  func removeAll() {
    do {
      try repository.removeAll()
      notifyURLsChanged()
    } catch {
      onError?("Failed to remove all URLs. Please try again.")
    }
  }
  
  func removeDuplicates(of item: URLItem) {
    do {
      try repository.removeDuplicates(of: item)
      notifyURLsChanged()
    } catch {
      onError?("Failed to remove duplicates. Please try again.")
    }
  }
  
  func open(_ item: URLItem) {
    onOpenURL?(item.url)
  }
  
  private func notifyURLsChanged() {
    onURLsChanged?(repository.urls)
  }
}
