//
//  WebViewController.swift
//  URLOrganizerUIKit
//
//  Created by Almira Khafizova on 04.07.26.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
  
  private let url: URL
  private let webView = WKWebView()
  
  init(url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = url.host
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Done",
      primaryAction: UIAction { [weak self] _ in
        self?.dismiss(animated: true)
      }
    )
    
    webView.load(URLRequest(url: url))
  }
}
