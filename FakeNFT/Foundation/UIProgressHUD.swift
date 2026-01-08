import ProgressHUD
import Foundation

final class UIProgressHUD {
    private static var isShowingProgress: Bool = false
    
    static func show() {
        if !UIProgressHUD.isShowingProgress {
            ProgressHUD.show()
        }
        UIProgressHUD.isShowingProgress = true
    }
    
    static func dismiss() {
        if UIProgressHUD.isShowingProgress {
            ProgressHUD.dismiss()
        }
        UIProgressHUD.isShowingProgress = false
    }
    
    static func showSuccess() {
        ProgressHUD.showSuccess(delay: 1.0)
    }
    
    static func showError(_ title: String? = nil) {
        ProgressHUD.showError(title, delay: 1.0)
    }
    
    static func showProgress(_ value: CGFloat) {
        ProgressHUD.showProgress(
            NSLocalizedString("WebView.loadingTitle", comment: "") + "...",
            value
        )
        isShowingProgress = true
    }
}
