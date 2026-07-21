//
//  FileManagerStorageService.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import Foundation
import os.log

protocol StorageServiceProtocol {
  func loadData() async throws -> [URLItem]
  func saveData(_ items: [URLItem]) throws
}

final class FileManagerStorageService: StorageServiceProtocol {
  
  private let fileURL: URL
  
  init() {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    self.fileURL = documentsDirectory.appendingPathComponent("urls.json")
  }
  
  func loadData() async throws -> [URLItem] {
    try await Task.detached(priority: .utility) { [fileURL] in
      do {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([URLItem].self, from: data)
      } catch let error as DecodingError {
        os_log(
          "Decoding error: %{public}@",
          log: .default,
          type: .error,
          String(describing: error)
        )
        throw error
      } catch {
        os_log(
          "File read error: %{public}@",
          log: .default,
          type: .error,
          error.localizedDescription
        )
        throw error
      }
    }.value
  }
  
  func saveData(_ items: [URLItem]) throws {
    do {
      let encoded = try JSONEncoder().encode(items)
      try encoded.write(to: fileURL)
    } catch let error as EncodingError {
      os_log("Encoding error: %{public}@", log: .default, type: .error, String(describing: error))
      throw error
    } catch {
      os_log("File write error: %{public}@", log: .default, type: .error, error.localizedDescription)
      throw error
    }
  }
}
