

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        hideKeyboardWhenTappedAround()
        
    }
    
    
   

    func setBackgroundColor() {
        // self.view.backgroundColor = R.color.main_background()
    }
}
