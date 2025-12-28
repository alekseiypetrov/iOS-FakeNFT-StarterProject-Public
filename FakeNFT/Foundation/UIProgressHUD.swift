import UIKit
import ProgressHUD

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
}
