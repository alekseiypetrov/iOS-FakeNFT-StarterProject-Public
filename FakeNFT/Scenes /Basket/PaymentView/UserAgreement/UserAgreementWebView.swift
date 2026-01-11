import UIKit
import WebKit

protocol UserAgreementWebViewProtocol: AnyObject {
    func configure(_ presenter: UserAgreementPresenterProtocol)
    func startLoadingPage(withRequest request: URLRequest)
    func stopLoadingPage()
    func setNewProgressValue(_ newValue: CGFloat)
    func hideProgress()
    func showError()
}

final class UserAgreementWebView: UIViewController {
    
    // MARK: - UI-elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .nbBack),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Private Properties
    
    private var presenter: UserAgreementPresenterProtocol?
    private var observer: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Actions
    
    @objc
    private func backButtonPressed() { 
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            
            // webView Constraints
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupObserver() {
        observer = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] (_, _) in
                 guard let self else { return }
                 self.presenter?.updateProgress(toValue: self.webView.estimatedProgress)
             }
        )
    }
}

// MARK: - UserAgreementWebView + UserAgreementWebViewProtocol

extension UserAgreementWebView: UserAgreementWebViewProtocol {
    func configure(_ presenter: UserAgreementPresenterProtocol) {
        self.presenter = presenter
    }
    
    func startLoadingPage(withRequest request: URLRequest) {
        webView.load(request)
    }
    
    func stopLoadingPage() {
        if webView.isLoading {
            webView.stopLoading()
        }
    }
    
    func setNewProgressValue(_ newValue: CGFloat) {
        UIProgressHUD.showProgress(newValue)
    }
    
    func hideProgress() {
        UIProgressHUD.dismiss()
    }
    
    func showError() {
        UIProgressHUD.showError(NSLocalizedString("WebView.invalidRequest", comment: ""))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backButtonPressed()
        }
    }
}
