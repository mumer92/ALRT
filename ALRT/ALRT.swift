import UIKit

/// Responsible for creating and managing an ALRT object.

open class ALRT {
    
    /**
     Result indicating whether the alert is displayed or not.
     
     - success: The alert is displayed.
     - failure: The alert is not displayed due to an ALRTError.
     */
    
    public enum Result {
        case success
        case failure(ALRTError)
    }
    
    /**
     ALRTError enums.
     
     - alertControllerNil: The alert controller is nil.
     - popoverNotSet: An attempt to show .ActionSheet type alert controller failed because the popover presentation controller has not been set up.
     */
    
    public enum ALRTError: Error {
        case alertControllerNil
        case popoverNotSet
        case sourceViewControllerNil
    }
    
    var alert: UIAlertController?
    
    fileprivate init(){}
    
    fileprivate init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle){
        self.alert = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: preferredStyle)
    }
    
    // MARK: Creating an ALRT
    
    /**
     Creates an ALRT object.
     
     - parameter style:   UIAlertControllerStyle constants indicating the type of alert to display.
     - parameter title:   The title of the alert.
     - parameter message: The message of the alert.
     
     - returns: ALRT
     */
    
    open class func create(_ style: UIAlertControllerStyle,
                             title: String? = nil,
                             message: String? = nil) -> ALRT {
        
        return ALRT(title: title, message: message, preferredStyle: style)
    }
    
    // MARK: Fetching the Alert
    
    /**
     Fetches the ALRT object's alert controller.
     
     - parameter handler: A block for fetching the alert controller. This block has no return value and takes the alert controller.
     
     - returns: Self
     */
    
    @discardableResult
    open func fetch(_ handler: ((_ alertController: UIAlertController?) -> Void)) -> Self {
        handler(self.alert)
        return self
    }
    
    // MARK: Configuring Text Fields
    
    /**
     Adds a text field to an alert.
     
     - parameter configurationHandler: A block for configuring the text field prior to displaying the alert. This block has no return value and takes a single parameter corresponding to the text field object. Use that parameter to change the text field properties.
     
     - returns: Self
     */
    
    @discardableResult
    open func addTextField(_ configurationHandler: ((_ textField: UITextField) -> Void)?) -> Self{
        guard alert?.preferredStyle == .alert else {
            return self
        }
        
        alert?.addTextField {
            textField in
            if let configurationHandler = configurationHandler {
                configurationHandler(textField)
            }
        }
        
        return self
    }
    
    // MARK: Configuring Customizable User Actions
    
    /**
     Attaches an action object to the alert or action sheet.
     
     - parameter title:     The title of the action’s button.
     - parameter style:     The style that is applied to the action’s button. The default value is .Default.
     - parameter preferred: The preferred action for the user to take from an alert(iOS 9 or later). The default value is false.
     - parameter handler:   A block to execute when the user selects the action. This block has no return value and take the selected action object and the text fields added to the alert controller if any. The default value is nil.
     
     - returns: Self
     */
    
    @discardableResult
    open func addAction(_ title: String?,
                          style: UIAlertActionStyle = .default,
                          preferred: Bool = false,
                          handler: ((_ action: UIAlertAction, _ textFields: [UITextField]?) -> Void)? = nil) -> Self {
        
        let action = UIAlertAction(title: title, style: style){ action in
            handler?(action, self.alert?.preferredStyle == .alert ? self.alert?.textFields : nil)
            self.alert = nil
        }
        
        alert?.addAction(action)
        
        if #available(iOS 9.0, *) {
            if preferred {
                alert?.preferredAction = action
            }
        }
        
        return self
    }
    
    // MARK: Configuring Pre-defined User Actions
    
    /**
     Attaches an action object to the alert or action sheet. The default title is "OK".
     
     - parameter title:     The title of the action’s button. The default value is "OK".
     - parameter style:     The style that is applied to the action’s button. The default value is .Default.
     - parameter preferred: The preferred action for the user to take from an alert(iOS 9 or later). The default value is false.
     - parameter handler:   A block to execute when the user selects the action. This block has no return value and take the selected action object and the text fields added to the alert controller if any. The default value is nil.

     - returns: Self
     */
    
    @discardableResult
    open func addOK(_ title: String = "OK",
                      style: UIAlertActionStyle = .default,
                      preferred: Bool = false,
                      handler:((_ action: UIAlertAction, _ textFields: [UITextField]?) -> Void)? = nil) -> Self {
        
        return addAction(title, style: style, preferred: preferred, handler: handler)
    }
    
    /**
     Attaches an action object to the alert or action sheet. The default title is "Cancel".
     
     - parameter title:     The title of the action’s button. The default value is "Cancel".
     - parameter style:     The style that is applied to the action’s button. The default value is .Cancel.
     - parameter preferred: The preferred action for the user to take from an alert(iOS 9 or later). The default value is false.
     - parameter handler:   A block to execute when the user selects the action. This block has no return value and take the selected action object and the text fields added to the alert controller if any. The default value is nil.
     
     - returns: Self
     */
    
    @discardableResult
    open func addCancel(_ title: String = "Cancel",
                          style: UIAlertActionStyle = .cancel,
                          preferred: Bool = false,
                          handler: ((_ action: UIAlertAction, _ textFields: [UITextField]?) -> Void)? = nil) -> Self {
        
        return addAction(title, style: style, preferred: preferred, handler: handler)
    }
    
    /**
     Attaches an action object to the alert or action sheet. The default style is .Destructive.
     
     - parameter title:     The title of the action’s button.
     - parameter style:     The style that is applied to the action’s button. The default value is .Destructive.
     - parameter preferred: The preferred action for the user to take from an alert(iOS 9 or later). The default value is false.
     - parameter handler:   A block to execute when the user selects the action. This block has no return value and take the selected action object and the text fields added to the alert controller if any. The default value is nil.
     
     - returns: Self
     */
    
    @discardableResult
    open func addDestructive(_ title: String?,
                               style: UIAlertActionStyle = .destructive,
                               preferred: Bool = false,
                               handler: ((_ action: UIAlertAction, _ textFields: [UITextField]?) -> Void)? = nil)-> Self {
        
        return addAction(title, style: style, preferred: preferred, handler: handler)
    }
    
    // MARK: Configuring the Popover Presentation
    
    /** Configures the alert controller's popover presentation controller.
     
     
     - parameter configurationHandler: A block for configuring the popover presentation controller. This block has no return value and take the alert controller's popover presentation controller. If the alert controller's style is .ActionSheet and the device is iPad, this configuration is necessary.
     
     - returns: Self
     */
    
    @discardableResult
    open func configurePopoverPresentation(_ configurationHandler:((_ popover: UIPopoverPresentationController?) -> Void)? = nil) -> Self {
        
        configurationHandler?(alert?.popoverPresentationController)
        
        return self
    }
    
    // MARK: Showing the Alert
    
    /**
     Displays the alert or action sheet.
     
     - parameter viewControllerToPresent: The view controller to display the alert from. The default value is nil. If the parameter is not given, the key window's root view controller will present the alert.
     - parameter animated:       Pass true to animate the presentation; otherwise, pass false. The default value is true.
     - parameter completion:     The block to execute after the presentation finishes. This block has no return value and takes an Result parameter. The default value is nil.
     */
    
    open func show(_ viewControllerToPresent: UIViewController? = nil,
                     animated: Bool = true,
                     completion: @escaping ((ALRT.Result) -> Void) = {_ in } ) {
        
        guard let alert = self.alert else {
            completion(.failure(.alertControllerNil))
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad &&
            alert.preferredStyle == .actionSheet &&
            alert.popoverPresentationController?.sourceView == nil &&
            alert.popoverPresentationController?.barButtonItem == nil {
            completion(.failure(.popoverNotSet))
            return
        }
        
        let sourceViewController: UIViewController? = {
            let viewController = viewControllerToPresent ?? UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = viewController as? UINavigationController {
                return navigationController.visibleViewController
            }
            return viewController
        }()

        if let sourceViewController = sourceViewController {
            sourceViewController.present(alert, animated: animated) {
                completion(.success)
            }
        } else {
            completion(.failure(.sourceViewControllerNil))
        }
    }
    
}
