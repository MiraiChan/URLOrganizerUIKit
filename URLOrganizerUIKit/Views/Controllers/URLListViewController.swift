//
//  URLListViewController.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import UIKit

@MainActor
final class URLListViewController: UIViewController {
  
  private let viewModel: URLListViewModel
  private var urls: [URLItem] = []
  
  private let emptyStateView: EmptyStateView = {
    let view = EmptyStateView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let textField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter a web URL"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .URL
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.returnKeyType = .done
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    return tableView
  }()
  
  private lazy var addButton: UIButton = {
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Add URL"
    configuration.cornerStyle = .large
    configuration.baseBackgroundColor = .black
    
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    return button
  }()
  
  init(viewModel: URLListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupTableView()
    setupLayout()
    bindViewModel()
    
    Task {
      await viewModel.loadURLs()
    }
  }
  
  private func setupView() {
    title = "URL Organizer"
    view.backgroundColor = .systemBackground
    
    view.addSubview(textField)
    view.addSubview(tableView)
    view.addSubview(emptyStateView)
    view.addSubview(addButton)
    
    textField.delegate = self
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(
      URLTableViewCell.self,
      forCellReuseIdentifier: URLTableViewCell.reuseIdentifier
    )
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      textField.heightAnchor.constraint(equalToConstant: 44),
      
      tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
      
      emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor),
      emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
      emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
      emptyStateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
      
      addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      addButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private func updateUI(with urls: [URLItem]) {
    self.urls = urls
    tableView.reloadData()
    
    let isEmpty = urls.isEmpty
    emptyStateView.isHidden = !isEmpty
    tableView.isHidden = isEmpty
  }
  
  private func bindViewModel() {
    viewModel.onURLsChanged = { [weak self] urls in
      
      guard let self = self else { return }
      
      let previousCount = self.urls.count
      self.updateUI(with: urls)
      
      if urls.count > previousCount {
        self.textField.text = nil
      }
    }
    
    viewModel.onError = { [weak self] message in
      
      self?.showAlert(title: "Error", message: message)
    }
    
    viewModel.onOpenURL = { [weak self] url in
      
      let webViewController = WebViewController(url: url)
      let navigationController = UINavigationController(rootViewController: webViewController)
      self?.present(navigationController, animated: true)
    }
  }
  
  @objc private func addButtonTapped() {
    textField.resignFirstResponder()
    viewModel.addURL(from: textField.text ?? "")
  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}

extension URLListViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    urls.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: URLTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? URLTableViewCell else {
      return UITableViewCell()
    }
    
    cell.configure(with: urls[indexPath.row])
    return cell
  }
}

extension URLListViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.open(urls[indexPath.row])
  }
  
  func tableView(
    _ tableView: UITableView,
    contextMenuConfigurationForRowAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    let item = urls[indexPath.row]
    
    return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
      UIMenu(children: [
        UIAction(title: "Edit") { _ in
          self?.textField.text = item.url.absoluteString
          self?.textField.becomeFirstResponder()
        },
        UIAction(title: "Remove", attributes: .destructive) { _ in
          self?.viewModel.remove(item)
        },
        UIAction(title: "Remove All", attributes: .destructive) { _ in
          self?.viewModel.removeAll()
        },
        UIAction(title: "Remove Duplicates") { _ in
          self?.viewModel.removeDuplicates(of: item)
        }
      ])
    })
  }
}

extension URLListViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
