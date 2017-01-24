//
//  IQKeyboardManager.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-16 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation
import CoreGraphics
import UIKit

///---------------------
/// MARK: IQToolbar tags
///---------------------

/**
Codeless drop-in universal library allows to prevent issues of keyboard sliding up and cover UITextField/UITextView. Neither need to write any code nor any setup required and much more. A generic version of KeyboardManagement. https://developer.apple.com/Library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
*/

open class IQKeyboardManager: NSObject, UIGestureRecognizerDelegate {
    
    /**
    Default tag for toolbar with Done button   -1002.
    */
    fileprivate;; static let  kIQDoneButtonToolbarTag         =   -1002
    
    /**
    Default tag for toolbar with Previous/Next buttons -1005.
    */
    fileprivate;; static let  kIQPreviousNextButtonToolbarTag =   -1005
    
    ///---------------------------
    ///  MARK: UIKeyboard handling
    ///---------------------------
    
    /**
    Enable/disable managing distance between keyboard and textField. Default is YES(Enabled when class loads in `+(void)load` method).
    */
    open;; var enable = false {
        
        didSet {
            //If not enable, enable it.
            if enable == true && oldValue == false {
                //If keyboard is currently showing. Sending a fake notification for keyboardWillShow to adjust view according to keyboard.
                if _kbShowNotification != nil {
                    keyboardWillShow(_kbShowNotification)
                }
                _IQShowLog("enabled")
            } else if enable == false && oldValue == true {   //If not disable, desable it.
                keyboardWillHide(nil)
                _IQShowLog("disabled")
            }
        }
    }
    
    open;; func privateIsEnabled()-> Bool {
        
        var isEnabled = enable;
        
        if let textFieldViewController = _textFieldView?.viewController() {
            
            if isEnabled == false {
                
                //If viewController is kind of enable viewController class, then assuming it's enabled.
                for enabledClassString in enabledDistanceHandlingClasses {
                    
                    if let enabledClass = NSClassFromString(enabledClassString) {
                        
                        if textFieldViewController.isKind(of: enabledClass) {
                            isEnabled = true;
                            break
                        }
                    }
                }
            }
            
            if isEnabled == true {
                
                //If viewController is kind of disabled viewController class, then assuming it's disabled.
                for diabledClassString in disabledDistanceHandlingClasses {
                    
                    if let disabledClass = NSClassFromString(diabledClassString) {
                        
                        if textFieldViewController.isKind(of: disabledClass) {
                            isEnabled = false;
                            break
                        }
                    }
                }
            }
        }
        
        return isEnabled;
    }
    
    /**
    To set keyboard distance from textField. can't be less than zero. Default is 10.0.
    */
    open;; var keyboardDistanceFromTextField: CGFloat {
        
        set {
            _privateKeyboardDistanceFromTextField =  max(0, newValue)
            _IQShowLog("keyboardDistanceFromTextField: \(_privateKeyboardDistanceFromTextField)")
        }
        get {
            return _privateKeyboardDistanceFromTextField
        }
    }

    /**
    Prevent keyboard manager to slide up the rootView to more than keyboard height. Default is YES.
    */
    open;; var preventShowingBottomBlankSpace = true
    
    /**
    Returns the default singleton instance.
    */
    open;; class func sharedManager() -> IQKeyboardManager {
        
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let kbManager = IQKeyboardManager()
        }
        
        /** @return Returns the default singleton instance. */
        return Static.kbManager
    }
    
    ///-------------------------
    /// MARK: IQToolbar handling
    ///-------------------------
    
    /**
    Automatic add the IQToolbar functionality. Default is YES.
    */
    open;; var enableAutoToolbar = true {
        
        didSet {

            privateIsEnableAutoToolbar() ?addToolbarIfRequired():removeToolbarIfRequired()

            let enableToolbar = enableAutoToolbar ? "Yes" : "NO"

            _IQShowLog("enableAutoToolbar: \(enableToolbar)")
        }
    }
    
    fileprivate;; func privateIsEnableAutoToolbar() -> Bool {
        
        var enableToolbar = enableAutoToolbar;
        
        if let textFieldViewController = _textFieldView?.viewController() {
            
            if enableToolbar == false {
                
                //If found any toolbar enabled classes then return.
                for enabledClassString in enabledToolbarClasses {
                    
                    if let enabledClass = NSClassFromString(enabledClassString) {
                        
                        if textFieldViewController.isKind(of: enabledClass) {
                            enableToolbar = true;
                            break
                        }
                    }
                }
            }
            
            if enableToolbar == true {
                
                //If found any toolbar disabled classes then return.
                for diabledClassString in disabledToolbarClasses {
                    
                    if let disabledClass = NSClassFromString(diabledClassString) {
                        
                        if textFieldViewController.isKind(of: disabledClass) {
                            enableToolbar = false;
                            break
                        }
                    }
                }
            }
        }

        return enableToolbar;
    }

    /**
    AutoToolbar managing behaviour. Default is IQAutoToolbarBySubviews.
    */
    open;; var toolbarManageBehaviour = IQAutoToolbarManageBehaviour.bySubviews

    /**
    If YES, then uses textField's tintColor property for IQToolbar, otherwise tint color is black. Default is NO.
    */
    open;; var shouldToolbarUsesTextFieldTintColor = false
    
    /**
    This is used for toolbar.tintColor when textfield.keyboardAppearance is UIKeyboardAppearanceDefault. If shouldToolbarUsesTextFieldTintColor is YES then this property is ignored. Default is nil and uses black color.
    */
    open;; var toolbarTintColor : UIColor?

    /**
     Toolbar done button icon, If nothing is provided then check toolbarDoneBarButtonItemText to draw done button.
     */
    open;; var toolbarDoneBarButtonItemImage : UIImage?
    
    /**
     Toolbar done button text, If nothing is provided then system default 'UIBarButtonSystemItemDone' will be used.
     */
    open;; var toolbarDoneBarButtonItemText : String?

    /**
    If YES, then it add the textField's placeholder text on IQToolbar. Default is YES.
    */
    open;; var shouldShowTextFieldPlaceholder = true
    
    /**
    Placeholder Font. Default is nil.
    */
    open;; var placeholderFont: UIFont?
    
    
    ///--------------------------
    /// MARK: UITextView handling
    ///--------------------------
    
    /**
    Adjust textView's frame when it is too big in height. Default is NO.
    */
    open;; var canAdjustTextView = false


    ///---------------------------------------
    /// MARK: UIKeyboard appearance overriding
    ///---------------------------------------

    /**
    Override the keyboardAppearance for all textField/textView. Default is NO.
    */
    open;; var overrideKeyboardAppearance = false
    
    /**
    If overrideKeyboardAppearance is YES, then all the textField keyboardAppearance is set using this property.
    */
    open;; var keyboardAppearance = UIKeyboardAppearance.;default

    
    ///-----------------------------------------------------------
    /// MARK: UITextField/UITextView Next/Previous/Resign handling
    ///-----------------------------------------------------------
    
    
    /**
    Resigns Keyboard on touching outside of UITextField/View. Default is NO.
    */
    open;; var shouldResignOnTouchOutside = false {
        
        didSet {
            _tapGesture.isEnabled = privateShouldResignOnTouchOutside()
            
            let shouldResign = shouldResignOnTouchOutside ? "Yes" : "NO"
            
            _IQShowLog("shouldResignOnTouchOutside: \(shouldResign)")
        }
    }
    
    fileprivate;; func privateShouldResignOnTouchOutside() -> Bool {
        
        var shouldResign = shouldResignOnTouchOutside;
        
        if let textFieldViewController = _textFieldView?.viewController() {
            
            if shouldResign == false {
                
                //If viewController is kind of enable viewController class, then assuming shouldResignOnTouchOutside is enabled.
                for enabledClassString in enabledTouchResignedClasses {
                    
                    if let enabledClass = NSClassFromString(enabledClassString) {
                        
                        if textFieldViewController.isKind(of: enabledClass) {
                            shouldResign = true;
                            break
                        }
                    }
                }
            }
            
            if shouldResign == true {
                
                //If viewController is kind of disable viewController class, then assuming shouldResignOnTouchOutside is disable.
                for diabledClassString in disabledTouchResignedClasses {
                    
                    if let disabledClass = NSClassFromString(diabledClassString) {
                        
                        if textFieldViewController.isKind(of: disabledClass) {
                            shouldResign = false;
                            break
                        }
                    }
                }
            }
        }
        
        return shouldResign;
    }
    
    /**
    Resigns currently first responder field.
    */
    open;; func resignFirstResponder()-> Bool {
        
        if let textFieldRetain = _textFieldView {
            
            //Resigning first responder
            let isResignFirstResponder = textFieldRetain.resignFirstResponder()
            
            //  If it refuses then becoming it as first responder again.    (Bug ID: #96)
            if isResignFirstResponder == false {
                //If it refuses to resign then becoming it first responder again for getting notifications callback.
                textFieldRetain.becomeFirstResponder()
                
                _IQShowLog("Refuses to resign first responder: \(_textFieldView?._IQDescription())")
            }
            
            return isResignFirstResponder
        }
        
        return false
    }
    
    /**
    Returns YES if can navigate to previous responder textField/textView, otherwise NO.
    */
    open;; var canGoPrevious: Bool {
        
        get {
            //Getting all responder view's.
            if let textFields = responderViews() {
                if let  textFieldRetain = _textFieldView {
                    
                    //Getting index of current textField.
                    if let index = textFields.index(of: textFieldRetain) {
                        
                        //If it is not first textField. then it's previous object canBecomeFirstResponder.
                        if index > 0 {
                            return true
                        }
                    }
                }
            }
            return false
        }
    }
    
    /**
    Returns YES if can navigate to next responder textField/textView, otherwise NO.
    */
    open;; var canGoNext: Bool {
        
        get {
            //Getting all responder view's.
            if let textFields = responderViews() {
                if let  textFieldRetain = _textFieldView {
                    //Getting index of current textField.
                    if let index = textFields.index(of: textFieldRetain) {
                        
                        //If it is not first textField. then it's previous object canBecomeFirstResponder.
                        if index < textFields.count-1 {
                            return true
                        }
                    }
                }
            }
            return false
        }
    }
    
    /**
    Navigate to previous responder textField/textView.
    */
    open;; func goPrevious()-> Bool {
        
        //Getting all responder view's.
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                //Getting index of current textField.
                if let index = textFields.index(of: textFieldRetain) {
                    
                    //If it is not first textField. then it's previous object becomeFirstResponder.
                    if index > 0 {
                        
                        let nextTextField = textFields[index-1]
                        
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        
                        //  If it refuses then becoming previous textFieldView as first responder again.    (Bug ID: #96)
                        if isAcceptAsFirstResponder == false {
                            //If next field refuses to become first responder then restoring old textField as first responder.
                            textFieldRetain.becomeFirstResponder()
                            
                            _IQShowLog("Refuses to become first responder: \(nextTextField._IQDescription())")
                        }
                        
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }
        
        return false
    }
    
    /**
    Navigate to next responder textField/textView.
    */
    open;; func goNext()-> Bool {

        //Getting all responder view's.
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                //Getting index of current textField.
                if let index = textFields.index(of: textFieldRetain) {
                    //If it is not last textField. then it's next object becomeFirstResponder.
                    if index < textFields.count-1 {
                        
                        let nextTextField = textFields[index+1]
                        
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        
                        //  If it refuses then becoming previous textFieldView as first responder again.    (Bug ID: #96)
                        if isAcceptAsFirstResponder == false {
                            //If next field refuses to become first responder then restoring old textField as first responder.
                            textFieldRetain.becomeFirstResponder()
                            
                            _IQShowLog("Refuses to become first responder: \(nextTextField._IQDescription())")
                        }
                        
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }

        return false
    }
    
    /**	previousAction. */
    internal func previousAction (_ barButton : UIBarButtonItem?) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if canGoPrevious == true {
            
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goPrevious()
                
                if isAcceptAsFirstResponder && textFieldRetain.previousInvocation.target != nil && textFieldRetain.previousInvocation.selector != nil {
                    
                    UIApplication.shared.sendAction(textFieldRetain.previousInvocation.selector!, to: textFieldRetain.previousInvocation.target, from: textFieldRetain, for: UIEvent())
                }
            }
        }
    }
    
    /**	nextAction. */
    internal func nextAction (_ barButton : UIBarButtonItem?) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if canGoNext == true {
            
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goNext()
                
                if isAcceptAsFirstResponder && textFieldRetain.nextInvocation.target != nil && textFieldRetain.nextInvocation.selector != nil {
                    
                    UIApplication.shared.sendAction(textFieldRetain.nextInvocation.selector!, to: textFieldRetain.nextInvocation.target, from: textFieldRetain, for: UIEvent())
                }
            }
        }
    }
    
    /**	doneAction. Resigning current textField. */
    internal func doneAction (_ barButton : IQBarButtonItem?) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if let textFieldRetain = _textFieldView {
            //Resign textFieldView.
            let isResignedFirstResponder = resignFirstResponder()
            
            if isResignedFirstResponder && textFieldRetain.doneInvocation.target != nil  && textFieldRetain.doneInvocation.selector != nil{
                
                UIApplication.shared.sendAction(textFieldRetain.doneInvocation.selector!, to: textFieldRetain.doneInvocation.target, from: textFieldRetain, for: UIEvent())
            }
        }
    }
    
    /** Resigning on tap gesture.   (Enhancement ID: #14)*/
    internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.ended {

            //Resigning currently responder textField.
            resignFirstResponder()
        }
    }
    
    /** Note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES. */
    open;; func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    /** To not detect touch events in a subclass of UIControl, these may have added their own selector for specific work */
    open;; func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)    (Bug ID: #145)
        return (touch.view is UIControl || touch.view is UINavigationBar) ? false : true
    }
    
    ///-----------------------
    /// MARK: UISound handling
    ///-----------------------

    /**
    If YES, then it plays inputClick sound on next/previous/done click.
    */
    open;; var shouldPlayInputClicks = false
    
    
    ///---------------------------
    /// MARK: UIAnimation handling
    ///---------------------------

    /**
    If YES, then uses keyboard default animation curve style to move view, otherwise uses UIViewAnimationOptionCurveEaseInOut animation style. Default is YES.
    
    @warning Sometimes strange animations may be produced if uses default curve style animation in iOS 7 and changing the textFields very frequently.
    */
    open;; var shouldAdoptDefaultKeyboardAnimation = true

    /**
    If YES, then calls 'setNeedsLayout' and 'layoutIfNeeded' on any frame update of to viewController's view.
    */
    open;; var layoutIfNeededOnUpdate = false

    
    ///------------------------------------
    /// MARK: Class Level disabling methods
    ///------------------------------------
    
    /**
     Disable distance handling within the scope of disabled distance handling viewControllers classes. Within this scope, 'enabled' property is ignored. Class should be kind of UIViewController.
     */
    open;; var disabledDistanceHandlingClasses  = Set<String>()
    
    /**
     Enable distance handling within the scope of enabled distance handling viewControllers classes. Within this scope, 'enabled' property is ignored. Class should be kind of UIViewController. If same Class is added in disabledDistanceHandlingClasses list, then enabledDistanceHandlingClasses will be ignored.
     */
    open;; var enabledDistanceHandlingClasses  = Set<String>()
    
    /**
     Disable automatic toolbar creation within the scope of disabled toolbar viewControllers classes. Within this scope, 'enableAutoToolbar' property is ignored. Class should be kind of UIViewController.
     */
    open;; var disabledToolbarClasses  = Set<String>()
    
    /**
     Enable automatic toolbar creation within the scope of enabled toolbar viewControllers classes. Within this scope, 'enableAutoToolbar' property is ignored. Class should be kind of UIViewController. If same Class is added in disabledToolbarClasses list, then enabledToolbarClasses will be ignore.
     */
    open;; var enabledToolbarClasses  = Set<String>()

    /**
     Allowed subclasses of UIView to add all inner textField, this will allow to navigate between textField contains in different superview. Class should be kind of UIView.
     */
    open;; var toolbarPreviousNextAllowedClasses  = Set<String>()
    
    /**
     Disabled classes to ignore 'shouldResignOnTouchOutside' property, Class should be kind of UIViewController.
     */
    open;; var disabledTouchResignedClasses  = Set<String>()
    
    /**
     Enabled classes to forcefully enable 'shouldResignOnTouchOutsite' property. Class should be kind of UIViewController. If same Class is added in disabledTouchResignedClasses list, then enabledTouchResignedClasses will be ignored.
     */
    open;; var enabledTouchResignedClasses  = Set<String>()

    /**
    Disable adjusting view in disabledClass
    
    @param disabledClass Class in which library should not adjust view to show textField.
    */
    @available(*,deprecated, message;;: "Use disabledDistanceHandlingClasses NSMutableSet, this will be removed in future releases.")
    open;; func disableDistanceHandlingInViewControllerClass(_ disabledClass : AnyClass) {
        disabledDistanceHandlingClasses.insert(NSStringFromClass(disabledClass))
    }
    
    /**
    Re-enable adjusting textField in disabledClass
    
    @param disabledClass Class in which library should re-enable adjust view to show textField.
    */
    @available(*,deprecated, message;;: "Use disabledDistanceHandlingClasses NSMutableSet, this will be removed in future releases.")
    open;; func removeDisableDistanceHandlingInViewControllerClass(_ disabledClass : AnyClass) {
        disabledDistanceHandlingClasses.remove(NSStringFromClass(disabledClass))
    }
    
    /**
    Disable automatic toolbar creation in in toolbarDisabledClass
    
    @param toolbarDisabledClass Class in which library should not add toolbar over textField.
    */
    @available(*,deprecated, message;;: "Use disabledToolbarClasses NSMutableSet, this will be removed in future releases.")
    open;; func disableToolbarInViewControllerClass(_ toolbarDisabledClass : AnyClass) {
        disabledToolbarClasses.insert(NSStringFromClass(toolbarDisabledClass))
    }
    
    /**
    Re-enable automatic toolbar creation in in toolbarDisabledClass
    
    @param toolbarDisabledClass Class in which library should re-enable automatic toolbar creation over textField.
     @available(*,deprecated, message="Use disabledDistanceHandlingClasses NSMutableSet, this will be removed in future releases.")
    */
    @available(*,deprecated, message;;: "Use disabledToolbarClasses NSMutableSet, this will be removed in future releases.")
    open;; func removeDisableToolbarInViewControllerClass(_ toolbarDisabledClass : AnyClass) {
        disabledToolbarClasses.remove(NSStringFromClass(toolbarDisabledClass))
    }

    /**
    Consider provided customView class as superView of all inner textField for calculating next/previous button logic.
    
    @param toolbarPreviousNextConsideredClass Custom UIView subclass Class in which library should consider all inner textField as siblings and add next/previous accordingly.
    */
    @available(*,deprecated, message;;: "Use toolbarPreviousNextAllowedClasses NSMutableSet, this will be removed in future releases.")
    open;; func considerToolbarPreviousNextInViewClass(_ toolbarPreviousNextConsideredClass : AnyClass) {
        toolbarPreviousNextAllowedClasses.insert(NSStringFromClass(toolbarPreviousNextConsideredClass))
    }
    
    /**
    Remove Consideration for provided customView class as superView of all inner textField for calculating next/previous button logic.
    
    @param toolbarPreviousNextConsideredClass Custom UIView subclass Class in which library should remove consideration for all inner textField as superView.
    */
    @available(*,deprecated, message;;: "Use toolbarPreviousNextAllowedClasses NSMutableSet, this will be removed in future releases.")
    open;; func removeConsiderToolbarPreviousNextInViewClass(_ toolbarPreviousNextConsideredClass : AnyClass) {
        toolbarPreviousNextAllowedClasses.remove(NSStringFromClass(toolbarPreviousNextConsideredClass))
    }

    ///-------------------------------------------
    /// MARK: Third Party Library support
    /// Add TextField/TextView Notifications customised NSNotifications. For example while using YYTextView https://github.com/ibireme/YYText
    ///-------------------------------------------
    
    /**
    Add customised Notification for third party customised TextField/TextView. Please be aware that the NSNotification object must be idential to UITextField/UITextView NSNotification objects and customised TextField/TextView support must be idential to UITextField/UITextView.
    @param didBeginEditingNotificationName This should be identical to UITextViewTextDidBeginEditingNotification
    @param didEndEditingNotificationName This should be identical to UITextViewTextDidEndEditingNotification
    */
    
    open;; func addTextFieldViewDidBeginEditingNotificationName(_ didBeginEditingNotificationName : String, didEndEditingNotificationName : String) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidBeginEditing(_:)),    name: NSNotification.Name(rawValue: didBeginEditingNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidEndEditing(_:)),      name: NSNotification.Name(rawValue: didEndEditingNotificationName), object: nil)
    }

    /**************************************************************************************/
    ///------------------------
    /// MARK: Private variables
    ///------------------------

    /*******************************************/

    /** To save UITextField/UITextView object voa textField/textView notifications. */
    fileprivate weak var    _textFieldView: UIView?
    
    /** used with canAdjustTextView boolean. */
    fileprivate var         _textFieldViewIntialFrame = CGRect.zero
    
    /** To save rootViewController.view.frame. */
    fileprivate var         _topViewBeginRect = CGRect.zero
    
    /** To save rootViewController */
    fileprivate weak var    _rootViewController: UIViewController?
    
    /** To save topBottomLayoutConstraint original constant */
    fileprivate var         _layoutGuideConstraintInitialConstant: CGFloat  = 0.25

    /*******************************************/

    /** Variable to save lastScrollView that was scrolled. */
    fileprivate weak var    _lastScrollView: UIScrollView?
    
    /** LastScrollView's initial contentOffset. */
    fileprivate var         _startingContentOffset = CGPoint.zero
    
    /** LastScrollView's initial scrollIndicatorInsets. */
    fileprivate var         _startingScrollIndicatorInsets = UIEdgeInsets.zero
    
    /** LastScrollView's initial contentInsets. */
    fileprivate var         _startingContentInsets = UIEdgeInsets.zero
    
    /*******************************************/

    /** To save keyboardWillShowNotification. Needed for enable keyboard functionality. */
    fileprivate var         _kbShowNotification: Notification?
    
    /** To save keyboard size. */
    fileprivate var         _kbSize = CGSize.zero
    
    /** To save keyboard animation duration. */
    fileprivate var         _animationDuration = 0.25
    
    /** To mimic the keyboard animation */
    fileprivate var         _animationCurve = UIViewAnimationOptions.curveEaseOut
    
    /*******************************************/

    /** TapGesture to resign keyboard on view's touch. */
    fileprivate var         _tapGesture: UITapGestureRecognizer!
    
    /*******************************************/
    
    fileprivate struct flags {
        /** used with canAdjustTextView to detect a textFieldView frame is changes or not. (Bug ID: #92)*/
        var isTextFieldViewFrameChanged = false
        /** Boolean to maintain keyboard is showing or it is hide. To solve rootViewController.view.frame calculations. */
        var isKeyboardShowing = false
    }
    
    /** Private flags to use within the project */
    fileprivate var _keyboardManagerFlags = flags(isTextFieldViewFrameChanged: false, isKeyboardShowing: false)

    /** To use with keyboardDistanceFromTextField. */
    fileprivate var         _privateKeyboardDistanceFromTextField: CGFloat = 10.0
    
    /**************************************************************************************/
    
    ///--------------------------------------
    /// MARK: Initialization/Deinitialization
    ///--------------------------------------
    
    /*  Singleton Object Initialization. */
    override init() {
        
        super.init()

        //  Registering for keyboard notification.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),                name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),                name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)),                name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        //  Registering for UITextField notification.
        addTextFieldViewDidBeginEditingNotificationName(NSNotification.Name.UITextFieldTextDidBeginEditing.rawValue, didEndEditingNotificationName: NSNotification.Name.UITextFieldTextDidEndEditing.rawValue)
        
        //  Registering for UITextView notification.
        addTextFieldViewDidBeginEditingNotificationName(NSNotification.Name.UITextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: NSNotification.Name.UITextViewTextDidEndEditing.rawValue)
        
        //  Registering for orientation changes notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.willChangeStatusBarOrientation(_:)),          name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)

        //Creating gesture for @shouldResignOnTouchOutside. (Enhancement ID: #14)
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        _tapGesture.cancelsTouchesInView = false
        _tapGesture.delegate = self
        _tapGesture.isEnabled = shouldResignOnTouchOutside
        
        disabledDistanceHandlingClasses.insert(NSStringFromClass(UITableViewController))
        toolbarPreviousNextAllowedClasses.insert(NSStringFromClass(UITableView))
        toolbarPreviousNextAllowedClasses.insert(NSStringFromClass(UICollectionView))
        toolbarPreviousNextAllowedClasses.insert(NSStringFromClass(IQPreviousNextView))
        //Workaround to load all appearance proxies at startup
        let barButtonItem2 = IQTitleBarButtonItem()
        barButtonItem2.title = ""
        let toolbar = IQToolbar()
        toolbar.title = ""
    }
    
    /** Override +load method to enable KeyboardManager when class loader load IQKeyboardManager. Enabling when app starts (No need to write any code) */
    /** It doesn't work from Swift 1.2 */
//    override public class func load() {
//        super.load()
//        
//        //Enabling IQKeyboardManager.
//        IQKeyboardManager.sharedManager().enable = true
//    }
    
    deinit {
        //  Disable the keyboard manager.
        enable = false

        //Removing notification observers on dealloc.
        NotificationCenter.default.removeObserver(self)
    }
    
    /** Getting keyWindow. */
    fileprivate func keyWindow() -> UIWindow? {
        
        if let keyWindow = _textFieldView?.window {
            return keyWindow
        } else {
            
            struct Static {
                /** @abstract   Save keyWindow object for reuse.
                @discussion Sometimes [[UIApplication sharedApplication] keyWindow] is returning nil between the app.   */
                static var keyWindow : UIWindow?
            }

            /*  (Bug ID: #23, #25, #73)   */
            let originalKeyWindow = UIApplication.shared.keyWindow
            
            //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
            if originalKeyWindow != nil && (Static.keyWindow == nil || Static.keyWindow != originalKeyWindow) {
                Static.keyWindow = originalKeyWindow
            }

            //Return KeyWindow
            return Static.keyWindow
        }
    }

    ///-----------------------
    /// MARK: Helper Functions
    ///-----------------------
    
    /*  Helper function to manipulate RootViewController's frame with animation. */
    fileprivate func setRootViewFrame(_ frame: CGRect) {
        
        //  Getting topMost ViewController.
        var controller = _textFieldView?.topMostController()
        
        if controller == nil {
            controller = keyWindow()?.topMostController()
        }
        
        if let unwrappedController = controller {
            
            var newFrame = frame;
            //frame size needs to be adjusted on iOS8 due to orientation structure changes.
            newFrame.size = unwrappedController.view.frame.size
            
            //Used UIViewAnimationOptionBeginFromCurrentState to minimize strange animations.
            UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                
                //  Setting it's new frame
                unwrappedController.view.frame = newFrame
                self._IQShowLog("Set \(controller?._IQDescription()) frame to : \(newFrame)")
                
                //Animating content if needed (Bug ID: #204)
                if self.layoutIfNeededOnUpdate == true {
                    //Animating content (Bug ID: #160)
                    unwrappedController.view.setNeedsLayout()
                    unwrappedController.view.layoutIfNeeded()
                }
 
                
                }) { (animated:Bool) -> Void in}
        } else {  //  If can't get rootViewController then printing warning to user.
            _IQShowLog("You must set UIWindow.rootViewController in your AppDelegate to work with IQKeyboardManager")
        }
    }

    /* Adjusting RootViewController's frame according to interface orientation. */
    fileprivate func adjustFrame() {
        
        //  We are unable to get textField object while keyboard showing on UIWebView's textField.  (Bug ID: #11)
        if _textFieldView == nil {
            return
        }
        
        let textFieldView = _textFieldView!

        _IQShowLog("****** \(#function) %@ started ******")

        //  Boolean to know keyboard is showing/hiding
        _keyboardManagerFlags.isKeyboardShowing = true
        
        //  Getting KeyWindow object.
        let optionalWindow = keyWindow()
        
        //  Getting RootViewController.  (Bug ID: #1, #4)
        var optionalRootController = _textFieldView?.topMostController()
        if optionalRootController == nil {
            optionalRootController = keyWindow()?.topMostController()
        }
        
        //  Converting Rectangle according to window bounds.
        let optionalTextFieldViewRect = textFieldView.superview?.convert(textFieldView.frame, to: optionalWindow)

        if optionalRootController == nil || optionalWindow == nil || optionalTextFieldViewRect == nil {
            return
        }
        
        let rootController = optionalRootController!
        let window = optionalWindow!
        let textFieldViewRect = optionalTextFieldViewRect!
        
        //  Getting RootViewRect.
        var rootViewRect = rootController.view.frame
        //Getting statusBarFrame

        //Maintain keyboardDistanceFromTextField
        let newKeyboardDistanceFromTextField = (textFieldView.keyboardDistanceFromTextField == kIQUseDefaultKeyboardDistance) ? keyboardDistanceFromTextField : textFieldView.keyboardDistanceFromTextField
        var kbSize = _kbSize
        kbSize.height += newKeyboardDistanceFromTextField

        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        //  (Bug ID: #250)
        var layoutGuidePosition = IQLayoutGuidePosition.none
        
        if let viewController = textFieldView.viewController() {
            
            if let constraint = viewController.IQLayoutGuideConstraint {
                
                var layoutGuide : UILayoutSupport?
                if let itemLayoutGuide = constraint.firstItem as? UILayoutSupport {
                    layoutGuide = itemLayoutGuide
                } else if let itemLayoutGuide = constraint.secondItem as? UILayoutSupport {
                    layoutGuide = itemLayoutGuide
                }
                
                if let itemLayoutGuide : UILayoutSupport = layoutGuide {
                    
                    if (itemLayoutGuide === viewController.topLayoutGuide)    //If topLayoutGuide constraint
                    {
                        layoutGuidePosition = .top
                    }
                    else if (itemLayoutGuide === viewController.bottomLayoutGuide)    //If bottomLayoutGuice constraint
                    {
                        layoutGuidePosition = .bottom
                    }
                }
            }
        }
        
        let topLayoutGuide : CGFloat = statusBarFrame.height

        var move : CGFloat = 0.0
        //  Move positive = textField is hidden.
        //  Move negative = textField is showing.
        
        //  Checking if there is bottomLayoutGuide attached (Bug ID: #250)
        if layoutGuidePosition == .bottom {
            //  Calculating move position.
            move = textFieldViewRect.maxY-(window.frame.height-kbSize.height)
        } else {
            //  Calculating move position. Common for both normal and special cases.
            move = min(textFieldViewRect.minY-(topLayoutGuide+5), textFieldViewRect.maxY-(window.frame.height-kbSize.height))
        }
        
        _IQShowLog("Need to move: \(move)")

        //  Getting it's superScrollView.   //  (Enhancement ID: #21, #24)
        let superScrollView = textFieldView.superviewOfClassType(UIScrollView) as? UIScrollView
        
        //If there was a lastScrollView.    //  (Bug ID: #34)
        if let lastScrollView = _lastScrollView {
            //If we can't find current superScrollView, then setting lastScrollView to it's original form.
            if superScrollView == nil {
                
                _IQShowLog("Restoring \(lastScrollView._IQDescription()) contentInset to : \(_startingContentInsets) and contentOffset to : \(_startingContentOffset)")

                UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                    
                    lastScrollView.contentInset = self._startingContentInsets
                    lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                    }) { (animated:Bool) -> Void in }
                
                if lastScrollView.shouldRestoreScrollViewContentOffset == true {
                    lastScrollView.setContentOffset(_startingContentOffset, animated: true)
                }
                
                _startingContentInsets = UIEdgeInsets.zero
                _startingScrollIndicatorInsets = UIEdgeInsets.zero
                _startingContentOffset = CGPoint.zero
                _lastScrollView = nil
            } else if superScrollView != lastScrollView {     //If both scrollView's are different, then reset lastScrollView to it's original frame and setting current scrollView as last scrollView.
                
                _IQShowLog("Restoring \(lastScrollView._IQDescription()) contentInset to : \(_startingContentInsets) and contentOffset to : \(_startingContentOffset)")
                
                UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                    
                    lastScrollView.contentInset = self._startingContentInsets
                    lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                    }) { (animated:Bool) -> Void in }
                
                if lastScrollView.shouldRestoreScrollViewContentOffset == true {
                    lastScrollView.setContentOffset(_startingContentOffset, animated: true)
                }

                _lastScrollView = superScrollView
                _startingContentInsets = superScrollView!.contentInset
                _startingScrollIndicatorInsets = superScrollView!.scrollIndicatorInsets
                _startingContentOffset = superScrollView!.contentOffset
                
                _IQShowLog("Saving New \(lastScrollView._IQDescription()) contentInset : \(_startingContentInsets) and contentOffset : \(_startingContentOffset)")
            }
            //Else the case where superScrollView == lastScrollView means we are on same scrollView after switching to different textField. So doing nothing, going ahead
        } else if let unwrappedSuperScrollView = superScrollView {    //If there was no lastScrollView and we found a current scrollView. then setting it as lastScrollView.
            _lastScrollView = unwrappedSuperScrollView
            _startingContentInsets = unwrappedSuperScrollView.contentInset
            _startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
            _startingContentOffset = unwrappedSuperScrollView.contentOffset

            _IQShowLog("Saving \(unwrappedSuperScrollView._IQDescription()) contentInset : \(_startingContentInsets) and contentOffset : \(_startingContentOffset)")
        }
        
        //  Special case for ScrollView.
        //  If we found lastScrollView then setting it's contentOffset to show textField.
        if let lastScrollView = _lastScrollView {
            //Saving
            var lastView = textFieldView
            var superScrollView = _lastScrollView
            
            while let scrollView = superScrollView {
                
                //Looping in upper hierarchy until we don't found any scrollView in it's upper hirarchy till UIWindow object.
                if move > 0 ? (move > (-scrollView.contentOffset.y - scrollView.contentInset.top)) : scrollView.contentOffset.y>0 {
                    
                    //Getting lastViewRect.
                    if let lastViewRect = lastView.superview?.convert(lastView.frame, to: scrollView) {
                        
                        //Calculating the expected Y offset from move and scrollView's contentOffset.
                        var shouldOffsetY = scrollView.contentOffset.y - min(scrollView.contentOffset.y,-move)
                        
                        //Rearranging the expected Y offset according to the view.
                        shouldOffsetY = min(shouldOffsetY, lastViewRect.origin.y /*-5*/)   //-5 is for good UI.//Commenting -5 (Bug ID: #69)

                        //[_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
                        //[superScrollView superviewOfClassType:[UIScrollView class]] == nil    If processing scrollView is last scrollView in upper hierarchy (there is no other scrollView upper hierrchy.)
                        //[_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
                        //shouldOffsetY >= 0     shouldOffsetY must be greater than in order to keep distance from navigationBar (Bug ID: #92)
                        if textFieldView is UITextView == true && scrollView.superviewOfClassType(UIScrollView) == nil && shouldOffsetY >= 0 {
                            var maintainTopLayout : CGFloat = 0
                            
                            if let navigationBarFrame = textFieldView.viewController()?.navigationController?.navigationBar.frame {
                                maintainTopLayout = navigationBarFrame.maxY
                            }
                            
                            maintainTopLayout += 10.0 //For good UI
                            
                            //  Converting Rectangle according to window bounds.
                            if let currentTextFieldViewRect = textFieldView.superview?.convert(textFieldView.frame, to: window) {

                                //Calculating expected fix distance which needs to be managed from navigation bar
                                let expectedFixDistance = currentTextFieldViewRect.minY - maintainTopLayout
                                
                                //Now if expectedOffsetY (superScrollView.contentOffset.y + expectedFixDistance) is lower than current shouldOffsetY, which means we're in a position where navigationBar up and hide, then reducing shouldOffsetY with expectedOffsetY (superScrollView.contentOffset.y + expectedFixDistance)
                                shouldOffsetY = min(shouldOffsetY, scrollView.contentOffset.y + expectedFixDistance)

                                //Setting move to 0 because now we don't want to move any view anymore (All will be managed by our contentInset logic.
                                move = 0
                            }
                            else {
                                //Subtracting the Y offset from the move variable, because we are going to change scrollView's contentOffset.y to shouldOffsetY.
                                move -= (shouldOffsetY-scrollView.contentOffset.y)
                            }
                        }
                        else
                        {
                            //Subtracting the Y offset from the move variable, because we are going to change scrollView's contentOffset.y to shouldOffsetY.
                            move -= (shouldOffsetY-scrollView.contentOffset.y)
                        }
                        
                        //Getting problem while using `setContentOffset:animated:`, So I used animation API.
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                        
                            self._IQShowLog("Adjusting \(scrollView.contentOffset.y-shouldOffsetY) to \(scrollView._IQDescription()) ContentOffset")
                            
                            self._IQShowLog("Remaining Move: \(move)")
                            
                            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: shouldOffsetY)
                            }) { (animated:Bool) -> Void in }
                    }
                    
                    //  Getting next lastView & superScrollView.
                    lastView = scrollView
                    superScrollView = lastView.superviewOfClassType(UIScrollView) as? UIScrollView
                } else {
                    break
                }
            }
            
            //Updating contentInset
            if let lastScrollViewRect = lastScrollView.superview?.convert(lastScrollView.frame, to: window) {
                
                let bottom : CGFloat = kbSize.height-(window.frame.height-lastScrollViewRect.maxY)
                
                // Update the insets so that the scroll vew doesn't shift incorrectly when the offset is near the bottom of the scroll view.
                var movedInsets = lastScrollView.contentInset
                
                movedInsets.bottom = max(_startingContentInsets.bottom, bottom)
                
                _IQShowLog("\(lastScrollView._IQDescription()) old ContentInset : \(lastScrollView.contentInset)")
                
                //Getting problem while using `setContentOffset:animated:`, So I used animation API.
                UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                    lastScrollView.contentInset = movedInsets

                    var newInset = lastScrollView.scrollIndicatorInsets
                    newInset.bottom = movedInsets.bottom - 10
                    lastScrollView.scrollIndicatorInsets = newInset

                    }) { (animated:Bool) -> Void in }

                //Maintaining contentSize
                if lastScrollView.contentSize.height < lastScrollView.frame.size.height {
                    var contentSize = lastScrollView.contentSize
                    contentSize.height = lastScrollView.frame.size.height
                    lastScrollView.contentSize = contentSize
                }
                
                _IQShowLog("\(lastScrollView._IQDescription()) new ContentInset : \(lastScrollView.contentInset)")
            }
        }
        //Going ahead. No else if.
        
        if layoutGuidePosition == .top {

            let constraint = textFieldView.viewController()!.IQLayoutGuideConstraint!

            let constant = min(_layoutGuideConstraintInitialConstant, constraint.constant-move)
            
            UIView.animate(withDuration: _animationDuration, delay: 0, options: (_animationCurve.union(UIViewAnimationOptions.beginFromCurrentState)), animations: { () -> Void in
                
                constraint.constant = constant
                self._rootViewController?.view.setNeedsLayout()
                self._rootViewController?.view.layoutIfNeeded()
                
                }, completion: { (finished) -> Void in })

        } else if layoutGuidePosition == .bottom {
            
            let constraint = textFieldView.viewController()!.IQLayoutGuideConstraint!

            let constant = max(_layoutGuideConstraintInitialConstant, constraint.constant+move)
            
            UIView.animate(withDuration: _animationDuration, delay: 0, options: (_animationCurve.union(UIViewAnimationOptions.beginFromCurrentState)), animations: { () -> Void in
                
                constraint.constant = constant
                self._rootViewController?.view.setNeedsLayout()
                self._rootViewController?.view.layoutIfNeeded()
                
                }, completion: { (finished) -> Void in })

        } else {
            
            //Special case for UITextView(Readjusting the move variable when textView hight is too big to fit on screen)
            //_canAdjustTextView    If we have permission to adjust the textView, then let's do it on behalf of user  (Enhancement ID: #15)
            //_lastScrollView       If not having inside any scrollView, (now contentInset manages the full screen textView.
            //[_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
            //_isTextFieldViewFrameChanged  If frame is not change by library in past  (Bug ID: #92)
            if canAdjustTextView == true && _lastScrollView == nil && textFieldView is UITextView == true && _keyboardManagerFlags.isTextFieldViewFrameChanged == false {
                var textViewHeight = textFieldView.frame.height
                textViewHeight = min(textViewHeight, (window.frame.height-kbSize.height-(topLayoutGuide+5)))
                
                UIView.animate(withDuration: _animationDuration, delay: 0, options: (_animationCurve.union(UIViewAnimationOptions.beginFromCurrentState)), animations: { () -> Void in
                    
                    self._IQShowLog("\(textFieldView._IQDescription()) Old Frame : \(textFieldView.frame)")
                    
                    var textFieldViewRect = textFieldView.frame
                    textFieldViewRect.size.height = textViewHeight
                    textFieldView.frame = textFieldViewRect
                    self._keyboardManagerFlags.isTextFieldViewFrameChanged = true
                    
                    self._IQShowLog("\(textFieldView._IQDescription()) New Frame : \(textFieldView.frame)")
                    
                    }, completion: { (finished) -> Void in })
            }

            //  Special case for iPad modalPresentationStyle.
            if rootController.modalPresentationStyle == UIModalPresentationStyle.formSheet || rootController.modalPresentationStyle == UIModalPresentationStyle.pageSheet {
                
                _IQShowLog("Found Special case for Model Presentation Style: \(rootController.modalPresentationStyle)")
                
                //  +Positive or zero.
                if move >= 0 {
                    // We should only manipulate y.
                    rootViewRect.origin.y -= move
                    
                    //  From now prevent keyboard manager to slide up the rootView to more than keyboard height. (Bug ID: #93)
                    if preventShowingBottomBlankSpace == true {
                        let minimumY: CGFloat = (window.frame.height-rootViewRect.size.height-topLayoutGuide)/2-(kbSize.height-newKeyboardDistanceFromTextField)
                        
                        rootViewRect.origin.y = max(rootViewRect.minY, minimumY)
                    }
                    
                    _IQShowLog("Moving Upward")
                    //  Setting adjusted rootViewRect
                    setRootViewFrame(rootViewRect)
                } else {  //  -Negative
                    //  Calculating disturbed distance. Pull Request #3
                    let disturbDistance = rootViewRect.minY-_topViewBeginRect.minY
                    
                    //  disturbDistance Negative = frame disturbed.
                    //  disturbDistance positive = frame not disturbed.
                    if disturbDistance < 0 {
                        // We should only manipulate y.
                        rootViewRect.origin.y -= max(move, disturbDistance)
                        
                        _IQShowLog("Moving Downward")
                        //  Setting adjusted rootViewRect
                        setRootViewFrame(rootViewRect)
                    }
                }
            } else {  //If presentation style is neither UIModalPresentationFormSheet nor UIModalPresentationPageSheet then going ahead.(General case)
                //  +Positive or zero.
                if move >= 0 {
                    
                    rootViewRect.origin.y -= move

                    //  From now prevent keyboard manager to slide up the rootView to more than keyboard height. (Bug ID: #93)
                    if preventShowingBottomBlankSpace == true {
                        
                        rootViewRect.origin.y = max(rootViewRect.origin.y, min(0, -kbSize.height+newKeyboardDistanceFromTextField))
                    }
                    
                    _IQShowLog("Moving Upward")
                    //  Setting adjusted rootViewRect
                    setRootViewFrame(rootViewRect)
                } else {  //  -Negative
                    let disturbDistance : CGFloat = rootViewRect.minY-_topViewBeginRect.minY
                    
                    //  disturbDistance Negative = frame disturbed.
                    //  disturbDistance positive = frame not disturbed.
                    if disturbDistance < 0 {
                        
                        rootViewRect.origin.y -= max(move, disturbDistance)
                        
                        _IQShowLog("Moving Downward")
                        //  Setting adjusted rootViewRect
                        //  Setting adjusted rootViewRect
                        setRootViewFrame(rootViewRect)
                    }
                }
            }
        }

        _IQShowLog("****** \(#function) ended ******")
    }
    
    ///-------------------------------
    /// MARK: UIKeyboard Notifications
    ///-------------------------------

    /*  UIKeyboardWillShowNotification. */
    internal func keyboardWillShow(_ notification : Notification?) -> Void {
        
        _kbShowNotification = notification

        if privateIsEnabled() == false {
            return
        }
        
        _IQShowLog("****** \(#function) started ******")

        //Due to orientation callback we need to resave it's original frame.    //  (Bug ID: #46)
        //Added _isTextFieldViewFrameChanged check. Saving textFieldView current frame to use it with canAdjustTextView if textViewFrame has already not been changed. (Bug ID: #92)
        if _keyboardManagerFlags.isTextFieldViewFrameChanged == false && _textFieldView != nil {
            if let textFieldView = _textFieldView {
                _textFieldViewIntialFrame = textFieldView.frame
                _IQShowLog("Saving \(textFieldView._IQDescription()) Initial frame : \(_textFieldViewIntialFrame)")
            }
        }

        //  (Bug ID: #5)
        if _topViewBeginRect.equalTo(CGRect.zero) == true {
            //  keyboard is not showing(At the beginning only). We should save rootViewRect.
            _rootViewController = _textFieldView?.topMostController()
            if _rootViewController == nil {
                _rootViewController = keyWindow()?.topMostController()
            }
            
            if let unwrappedRootController = _rootViewController {
                _topViewBeginRect = unwrappedRootController.view.frame
                _IQShowLog("Saving \(unwrappedRootController._IQDescription()) beginning Frame: \(_topViewBeginRect)")
            } else {
                _topViewBeginRect = CGRect.zero
            }
        }

        let oldKBSize = _kbSize

        if let info = (notification as NSNotification?)?.userInfo {
            
            if shouldAdoptDefaultKeyboardAnimation {

                //  Getting keyboard animation.
                if let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uintValue {
                    _animationCurve = UIViewAnimationOptions(rawValue: curve)
                }
            } else {
                _animationCurve = UIViewAnimationOptions.curveEaseOut
            }
            
            //  Getting keyboard animation duration
            if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                
                //Saving animation duration
                if duration != 0.0 {
                    _animationDuration = duration
                }
            }
            
            //  Getting UIKeyboardSize.
            if let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }

                _IQShowLog("UIKeyboard Size : \(_kbSize)")
            }
        }
        
        //  Getting topMost ViewController.
        var topMostController = _textFieldView?.topMostController()
        
        if topMostController == nil {
            topMostController = keyWindow()?.topMostController()
        }

        //If last restored keyboard size is different(any orientation accure), then refresh. otherwise not.
        if _kbSize.equalTo(oldKBSize) == false {
            
            //If _textFieldView is inside UITableViewController then let UITableViewController to handle it (Bug ID: #37) (Bug ID: #76) See note:- https://developer.apple.com/Library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html. If it is UIAlertView textField then do not affect anything (Bug ID: #70).
            
            if _textFieldView != nil && _textFieldView?.isAlertViewTextField() == false {
                
                //Getting textField viewController
                if _textFieldView?.viewController() != nil {
                    
                    //  keyboard is already showing. adjust frame.
                    adjustFrame()
                }
            }
        }
        
        _IQShowLog("****** \(#function) ended ******")
    }
    
    /*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
    internal func keyboardWillHide(_ notification : Notification?) -> Void {
        
        //If it's not a fake notification generated by [self setEnable:NO].
        if notification != nil {
            _kbShowNotification = nil
        }
        
        //If not enabled then do nothing.
        if privateIsEnabled() == false {
            return
        }
        
        _IQShowLog("****** \(#function) started ******")

        //Commented due to #56. Added all the conditions below to handle UIWebView's textFields.    (Bug ID: #56)
        //  We are unable to get textField object while keyboard showing on UIWebView's textField.  (Bug ID: #11)
        //    if (_textFieldView == nil)   return

        //  Boolean to know keyboard is showing/hiding
        _keyboardManagerFlags.isKeyboardShowing = false
        
        let info : [AnyHashable: Any]? = (notification as NSNotification?)?.userInfo
        
        //  Getting keyboard animation duration
        if let duration =  (info?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            if duration != 0 {
                //  Setitng keyboard animation duration
                _animationDuration = duration
            }
        }
        
        //Restoring the contentOffset of the lastScrollView
        if let lastScrollView = _lastScrollView {
            
            UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                
                lastScrollView.contentInset = self._startingContentInsets
                lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                
                if lastScrollView.shouldRestoreScrollViewContentOffset == true {
                    lastScrollView.contentOffset = self._startingContentOffset
                }
                
                self._IQShowLog("Restoring \(lastScrollView._IQDescription()) contentInset to : \(self._startingContentInsets) and contentOffset to : \(self._startingContentOffset)")

                // TODO: restore scrollView state
                // This is temporary solution. Have to implement the save and restore scrollView state
                var superScrollView : UIScrollView? = lastScrollView

                while let scrollView = superScrollView {

                    let contentSize = CGSize(width: max(scrollView.contentSize.width, scrollView.frame.width), height: max(scrollView.contentSize.height, scrollView.frame.height))
                    
                    let minimumY = contentSize.height - scrollView.frame.height
                    
                    if minimumY < scrollView.contentOffset.y {
                        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minimumY)
                        
                        self._IQShowLog("Restoring \(scrollView._IQDescription()) contentOffset to : \(self._startingContentOffset)")
                    }
                    
                    superScrollView = scrollView.superviewOfClassType(UIScrollView) as? UIScrollView
                }
                }) { (finished) -> Void in }
        }
        
        //  Setting rootViewController frame to it's original position. //  (Bug ID: #18)
        if _topViewBeginRect.equalTo(CGRect.zero) == false {
            
            if let rootViewController = _rootViewController {
                
                //frame size needs to be adjusted on iOS8 due to orientation API changes.
                _topViewBeginRect.size = rootViewController.view.frame.size
                
                //Used UIViewAnimationOptionBeginFromCurrentState to minimize strange animations.
                UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                    
                    var hasDoneTweakLayoutGuide = false
                    
                    if let viewController = self._textFieldView?.viewController() {
                        
                        if let constraint = viewController.IQLayoutGuideConstraint {
                            
                            var layoutGuide : UILayoutSupport?
                            if let itemLayoutGuide = constraint.firstItem as? UILayoutSupport {
                                layoutGuide = itemLayoutGuide
                            } else if let itemLayoutGuide = constraint.secondItem as? UILayoutSupport {
                                layoutGuide = itemLayoutGuide
                            }
                            
                            if let itemLayoutGuide : UILayoutSupport = layoutGuide {
                                
                                if (itemLayoutGuide === viewController.topLayoutGuide || itemLayoutGuide === viewController.bottomLayoutGuide)
                                {
                                    constraint.constant = self._layoutGuideConstraintInitialConstant
                                    rootViewController.view.setNeedsLayout()
                                    rootViewController.view.layoutIfNeeded()

                                    hasDoneTweakLayoutGuide = true
                                }
                            }
                        }
                    }
                    
                    if hasDoneTweakLayoutGuide == false {
                        self._IQShowLog("Restoring \(rootViewController._IQDescription()) frame to : \(self._topViewBeginRect)")
                        
                        //  Setting it's new frame
                        rootViewController.view.frame = self._topViewBeginRect
                        
                        //Animating content if needed (Bug ID: #204)
                        if self.layoutIfNeededOnUpdate == true {
                            //Animating content (Bug ID: #160)
                            rootViewController.view.setNeedsLayout()
                            rootViewController.view.layoutIfNeeded()
                        }
                    }
                    }) { (finished) -> Void in }
                
                _rootViewController = nil
            }
        }
        
        //Reset all values
        _lastScrollView = nil
        _kbSize = CGSize.zero
        _startingContentInsets = UIEdgeInsets.zero
        _startingScrollIndicatorInsets = UIEdgeInsets.zero
        _startingContentOffset = CGPoint.zero
        //    topViewBeginRect = CGRectZero    //Commented due to #82

        _IQShowLog("****** \(#function) ended ******")
    }

    internal func keyboardDidHide(_ notification:Notification) {

        _IQShowLog("****** \(#function) started ******")
        
        _topViewBeginRect = CGRect.zero

        _IQShowLog("****** \(#function) ended ******")
    }
    
    ///-------------------------------------------
    /// MARK: UITextField/UITextView Notifications
    ///-------------------------------------------

    /**  UITextFieldTextDidBeginEditingNotification, UITextViewTextDidBeginEditingNotification. Fetching UITextFieldView object. */
    internal func textFieldViewDidBeginEditing(_ notification:Notification) {

        _IQShowLog("****** \(#function) started ******")

        //  Getting object
        _textFieldView = notification.object as? UIView
        
        if overrideKeyboardAppearance == true {
            
            if let textFieldView = _textFieldView as? UITextField {
                //If keyboard appearance is not like the provided appearance
                if textFieldView.keyboardAppearance != keyboardAppearance {
                    //Setting textField keyboard appearance and reloading inputViews.
                    textFieldView.keyboardAppearance = keyboardAppearance
                    textFieldView.reloadInputViews()
                }
            } else if  let textFieldView = _textFieldView as? UITextView {
                //If keyboard appearance is not like the provided appearance
                if textFieldView.keyboardAppearance != keyboardAppearance {
                    //Setting textField keyboard appearance and reloading inputViews.
                    textFieldView.keyboardAppearance = keyboardAppearance
                    textFieldView.reloadInputViews()
                }
            }
        }
        
        // Saving textFieldView current frame to use it with canAdjustTextView if textViewFrame has already not been changed.
        //Added _isTextFieldViewFrameChanged check. (Bug ID: #92)
        if _keyboardManagerFlags.isTextFieldViewFrameChanged == false {
            if let textFieldView = _textFieldView {
                _textFieldViewIntialFrame = textFieldView.frame
                _IQShowLog("Saving \(textFieldView._IQDescription()) Initial frame : \(_textFieldViewIntialFrame)")
            }
        }
        
        //If autoToolbar enable, then add toolbar on all the UITextField/UITextView's if required.
        if privateIsEnableAutoToolbar() == true {

            _IQShowLog("adding UIToolbars if required")

            //UITextView special case. Keyboard Notification is firing before textView notification so we need to resign it first and then again set it as first responder to add toolbar on it.
            if _textFieldView is UITextView == true && _textFieldView?.inputAccessoryView == nil {
                
                UIView.animate(withDuration: 0.00001, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in

                    self.addToolbarIfRequired()
                    
                    }, completion: { (finished) -> Void in

                        //RestoringTextView before reloading inputViews
                        if (self._keyboardManagerFlags.isTextFieldViewFrameChanged)
                        {
                            self._keyboardManagerFlags.isTextFieldViewFrameChanged = false
                            
                            if let textFieldView = self._textFieldView {
                                textFieldView.frame = self._textFieldViewIntialFrame
                            }
                        }

                        //On textView toolbar didn't appear on first time, so forcing textView to reload it's inputViews.
                        self._textFieldView?.reloadInputViews()
                })
            } else {
                //Adding toolbar
                addToolbarIfRequired()
            }
        } else {
            removeToolbarIfRequired()
        }

        if privateIsEnabled() == false {
            _IQShowLog("****** \(#function) ended ******")
            return
        }
        
        _textFieldView?.window?.addGestureRecognizer(_tapGesture)    //   (Enhancement ID: #14)

        if _keyboardManagerFlags.isKeyboardShowing == false {    //  (Bug ID: #5)

            //  keyboard is not showing(At the beginning only). We should save rootViewRect.
            if let constant = _textFieldView?.viewController()?.IQLayoutGuideConstraint?.constant {
                _layoutGuideConstraintInitialConstant = constant
            }

            _rootViewController = _textFieldView?.topMostController()
            if _rootViewController == nil {
                _rootViewController = keyWindow()?.topMostController()
            }

            if let rootViewController = _rootViewController {
                
                _topViewBeginRect = rootViewController.view.frame
                
                _IQShowLog("Saving \(rootViewController._IQDescription()) beginning frame : \(_topViewBeginRect)")
            }
        }
        
        //If _textFieldView is inside ignored responder then do nothing. (Bug ID: #37, #74, #76)
        //See notes:- https://developer.apple.com/Library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html. If it is UIAlertView textField then do not affect anything (Bug ID: #70).
        if _textFieldView != nil && _textFieldView?.isAlertViewTextField() == false {

            //Getting textField viewController
            if let textFieldViewController = _textFieldView?.viewController() {
                
                var shouldIgnore = false
                
                for disabledClassString in disabledDistanceHandlingClasses {
                    
                    if let disabledClass = NSClassFromString(disabledClassString) {
                        //If viewController is kind of disabled viewController class, then ignoring to adjust view.
                        if textFieldViewController.isKind(of: disabledClass) {
                            shouldIgnore = true
                            break
                        }
                    }
                }
                
                //If shouldn't ignore.
                if shouldIgnore == false  {
                    //  keyboard is already showing. adjust frame.
                    adjustFrame()
                }
            }
        }

        _IQShowLog("****** \(#function) ended ******")
    }
    
    /**  UITextFieldTextDidEndEditingNotification, UITextViewTextDidEndEditingNotification. Removing fetched object. */
    internal func textFieldViewDidEndEditing(_ notification:Notification) {
        
        _IQShowLog("****** \(#function) started ******")

        //Removing gesture recognizer   (Enhancement ID: #14)
        _textFieldView?.window?.removeGestureRecognizer(_tapGesture)
        
        // We check if there's a change in original frame or not.
        if _keyboardManagerFlags.isTextFieldViewFrameChanged == true {
            UIView.animate(withDuration: _animationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(_animationCurve), animations: { () -> Void in
                self._keyboardManagerFlags.isTextFieldViewFrameChanged = false
                
                self._IQShowLog("Restoring \(self._textFieldView?._IQDescription()) frame to : \(self._textFieldViewIntialFrame)")

                self._textFieldView?.frame = self._textFieldViewIntialFrame
                }, completion: { (finished) -> Void in })
        }
        
        //Setting object to nil
        _textFieldView = nil

        _IQShowLog("****** \(#function) ended ******")
    }

    ///------------------------------------------
    /// MARK: Interface Orientation Notifications
    ///------------------------------------------
    
    /**  UIApplicationWillChangeStatusBarOrientationNotification. Need to set the textView to it's original position. If any frame changes made. (Bug ID: #92)*/
    internal func willChangeStatusBarOrientation(_ notification:Notification) {
        
        _IQShowLog("****** \(#function) started ******")
        
        //If textFieldViewInitialRect is saved then restore it.(UITextView case @canAdjustTextView)
        if _keyboardManagerFlags.isTextFieldViewFrameChanged == true {
            if let textFieldView = _textFieldView {
                //Due to orientation callback we need to set it's original position.
                UIView.animate(withDuration: _animationDuration, delay: 0, options: (_animationCurve.union(UIViewAnimationOptions.beginFromCurrentState)), animations: { () -> Void in
                    self._keyboardManagerFlags.isTextFieldViewFrameChanged = false

                    self._IQShowLog("Restoring \(textFieldView._IQDescription()) frame to : \(self._textFieldViewIntialFrame)")
                    
                    //Setting textField to it's initial frame
                    textFieldView.frame = self._textFieldViewIntialFrame
                    
                    }, completion: { (finished) -> Void in })
            }
        }

        _IQShowLog("****** \(#function) ended ******")
    }
    
    ///------------------
    /// MARK: AutoToolbar
    ///------------------
    
    /**	Get all UITextField/UITextView siblings of textFieldView. */
    fileprivate func responderViews()-> [UIView]? {
        
        var superConsideredView : UIView?

        //If find any consider responderView in it's upper hierarchy then will get deepResponderView.
        for disabledClassString in toolbarPreviousNextAllowedClasses {
            
            if let disabledClass = NSClassFromString(disabledClassString) {
                
                superConsideredView = _textFieldView?.superviewOfClassType(disabledClass)
                
                if superConsideredView != nil {
                    break
                }
            }
        }
    
    //If there is a superConsideredView in view's hierarchy, then fetching all it's subview that responds. No sorting for superConsideredView, it's by subView position.    (Enhancement ID: #22)
        if superConsideredView != nil {
            return superConsideredView?.deepResponderViews()
        } else {  //Otherwise fetching all the siblings
            
            if let textFields = _textFieldView?.responderSiblings() {
                
                //Sorting textFields according to behaviour
                switch toolbarManageBehaviour {
                    //If autoToolbar behaviour is bySubviews, then returning it.
                case IQAutoToolbarManageBehaviour.bySubviews:   return textFields
                    
                    //If autoToolbar behaviour is by tag, then sorting it according to tag property.
                case IQAutoToolbarManageBehaviour.byTag:    return textFields.sortedArrayByTag()
                    
                    //If autoToolbar behaviour is by tag, then sorting it according to tag property.
                case IQAutoToolbarManageBehaviour.byPosition:    return textFields.sortedArrayByPosition()
                }
            } else {
                return nil
            }
        }
    }
    
    /** Add toolbar if it is required to add on textFields and it's siblings. */
    fileprivate func addToolbarIfRequired() {
        
        //	Getting all the sibling textFields.
        if let siblings = responderViews() {
            
            //	If only one object is found, then adding only Done button.
            if siblings.count == 1 {
                let textField = siblings[0]
                
                //Either there is no inputAccessoryView or if accessoryView is not appropriate for current situation(There is Previous/Next/Done toolbar).
                //setInputAccessoryView: check   (Bug ID: #307)
                if textField.responds(to: #selector(setter: UITextField.inputAccessoryView)) && (textField.inputAccessoryView == nil || textField.inputAccessoryView?.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag) {
                    
                    //Supporting Custom Done button image (Enhancement ID: #366)
                    if let doneBarButtonItemImage = toolbarDoneBarButtonItemImage {
                            textField.addRightButtonOnKeyboardWithImage(doneBarButtonItemImage, target: self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                    }
                    //Supporting Custom Done button text (Enhancement ID: #209, #411, Bug ID: #376)
                    else if let doneBarButtonItemText = toolbarDoneBarButtonItemText {
                        textField.addRightButtonOnKeyboardWithText(doneBarButtonItemText, target: self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                    } else {
                        //Now adding textField placeholder text as title of IQToolbar  (Enhancement ID: #27)
                        textField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                    }

                    textField.inputAccessoryView?.tag = IQKeyboardManager.kIQDoneButtonToolbarTag //  (Bug ID: #78)
                }
                
                if textField.inputAccessoryView is IQToolbar && textField.inputAccessoryView?.tag == IQKeyboardManager.kIQDoneButtonToolbarTag {
                    
                    let toolbar = textField.inputAccessoryView as! IQToolbar
                    
                    //  Setting toolbar to keyboard.
                    if let _textField = textField as? UITextField {

                        //Bar style according to keyboard appearance
                        switch _textField.keyboardAppearance {

                        case UIKeyboardAppearance.dark:
                            toolbar.barStyle = UIBarStyle.black
                            toolbar.tintColor = UIColor.white
                        default:
                            toolbar.barStyle = UIBarStyle.default
                            
                            //Setting toolbar tintColor //  (Enhancement ID: #30)
                            if shouldToolbarUsesTextFieldTintColor {
                                toolbar.tintColor = _textField.tintColor
                            } else if let tintColor = toolbarTintColor {
                                toolbar.tintColor = tintColor
                            } else {
                                toolbar.tintColor = UIColor.black
                            }
                        }
                    } else if let _textView = textField as? UITextView {

                        //Bar style according to keyboard appearance
                        switch _textView.keyboardAppearance {
                            
                        case UIKeyboardAppearance.dark:
                            toolbar.barStyle = UIBarStyle.black
                            toolbar.tintColor = UIColor.white
                        default:
                            toolbar.barStyle = UIBarStyle.default
                            
                            if shouldToolbarUsesTextFieldTintColor {
                                toolbar.tintColor = _textView.tintColor
                            } else if let tintColor = toolbarTintColor {
                                toolbar.tintColor = tintColor
                            } else {
                                toolbar.tintColor = UIColor.black
                            }
                        }
                    }

                    //Setting toolbar title font.   //  (Enhancement ID: #30)
                    if shouldShowTextFieldPlaceholder == true && textField.shouldHideTitle == false {
                        
                        //Updating placeholder font to toolbar.     //(Bug ID: #148)
                        if let _textField = textField as? UITextField {
                            
                            if toolbar.title == nil || toolbar.title != _textField.placeholder {
                                toolbar.title = _textField.placeholder
                            }

                        } else if let _textView = textField as? IQTextView {
                            
                            if toolbar.title == nil || toolbar.title != _textView.placeholder {
                                toolbar.title = _textView.placeholder
                            }
                        } else {
                            toolbar.title = nil
                        }

                        //Setting toolbar title font.   //  (Enhancement ID: #30)
                        if placeholderFont != nil {
                            toolbar.titleFont = placeholderFont
                        }
                    } else {
                        
                        toolbar.title = nil
                    }
                }
            } else if siblings.count != 0 {
                
                //	If more than 1 textField is found. then adding previous/next/done buttons on it.
                for textField in siblings {
                    
                    //Either there is no inputAccessoryView or if accessoryView is not appropriate for current situation(There is Done toolbar).
                    //setInputAccessoryView: check   (Bug ID: #307)
                    if textField.responds(to: #selector(setter: UITextField.inputAccessoryView)) && (textField.inputAccessoryView == nil || textField.inputAccessoryView?.tag == IQKeyboardManager.kIQDoneButtonToolbarTag) {
                        
                        //Supporting Custom Done button image (Enhancement ID: #366)
                        if let doneBarButtonItemImage = toolbarDoneBarButtonItemImage {
                            textField.addPreviousNextRightOnKeyboardWithTarget(self, rightButtonImage: doneBarButtonItemImage, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(self.nextAction(_:)), rightButtonAction: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                        }
                        //Supporting Custom Done button text (Enhancement ID: #209, #411, Bug ID: #376)
                        else if let doneBarButtonItemText = toolbarDoneBarButtonItemText {
                            textField.addPreviousNextRightOnKeyboardWithTarget(self, rightButtonTitle: doneBarButtonItemText, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(self.nextAction(_:)), rightButtonAction: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                        } else {
                            //Now adding textField placeholder text as title of IQToolbar  (Enhancement ID: #27)
                            textField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(self.nextAction(_:)), doneAction: #selector(self.doneAction(_:)), shouldShowPlaceholder: shouldShowTextFieldPlaceholder)
                        }

                        textField.inputAccessoryView?.tag = IQKeyboardManager.kIQPreviousNextButtonToolbarTag //  (Bug ID: #78)
                   }
                    
                    if textField.inputAccessoryView is IQToolbar && textField.inputAccessoryView?.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag {
                        
                        let toolbar = textField.inputAccessoryView as! IQToolbar
                        
                        //  Setting toolbar to keyboard.
                        if let _textField = textField as? UITextField {
                            
                            //Bar style according to keyboard appearance
                            switch _textField.keyboardAppearance {
                                
                            case UIKeyboardAppearance.dark:
                                toolbar.barStyle = UIBarStyle.black
                                toolbar.tintColor = UIColor.white
                            default:
                                toolbar.barStyle = UIBarStyle.default

                                if shouldToolbarUsesTextFieldTintColor {
                                    toolbar.tintColor = _textField.tintColor
                                } else if let tintColor = toolbarTintColor {
                                    toolbar.tintColor = tintColor
                                } else {
                                    toolbar.tintColor = UIColor.black
                                }
                            }
                        } else if let _textView = textField as? UITextView {
                            
                            //Bar style according to keyboard appearance
                            switch _textView.keyboardAppearance {
                                
                            case UIKeyboardAppearance.dark:
                                toolbar.barStyle = UIBarStyle.black
                                toolbar.tintColor = UIColor.white
                            default:
                                toolbar.barStyle = UIBarStyle.default

                                if shouldToolbarUsesTextFieldTintColor {
                                    toolbar.tintColor = _textView.tintColor
                                } else if let tintColor = toolbarTintColor {
                                    toolbar.tintColor = tintColor
                                } else {
                                    toolbar.tintColor = UIColor.black
                                }
                            }
                        }
                        
                        //Setting toolbar title font.   //  (Enhancement ID: #30)
                        if shouldShowTextFieldPlaceholder == true && textField.shouldHideTitle == false {
                            
                            //Updating placeholder font to toolbar.     //(Bug ID: #148)
                            if let _textField = textField as? UITextField {
                                
                                if toolbar.title == nil || toolbar.title != _textField.placeholder {
                                    toolbar.title = _textField.placeholder
                                }
                                
                            } else if let _textView = textField as? IQTextView {
                                
                                if toolbar.title == nil || toolbar.title != _textView.placeholder {
                                    toolbar.title = _textView.placeholder
                                }
                            } else {
                                toolbar.title = nil
                            }
                            
                            //Setting toolbar title font.   //  (Enhancement ID: #30)
                            if placeholderFont != nil {
                                toolbar.titleFont = placeholderFont
                            }
                        }
                        else {
                            
                            toolbar.title = nil
                        }

                        //In case of UITableView (Special), the next/previous buttons has to be refreshed everytime.    (Bug ID: #56)
                        //	If firstTextField, then previous should not be enabled.
                        if siblings[0] == textField {
                            textField.setEnablePrevious(false, isNextEnabled: true)
                        } else if siblings.last  == textField {   //	If lastTextField then next should not be enaled.
                            textField.setEnablePrevious(true, isNextEnabled: false)
                        } else {
                            textField.setEnablePrevious(true, isNextEnabled: true)
                        }
                    }
                }
            }
        }
    }
    
    /** Remove any toolbar if it is IQToolbar. */
    fileprivate func removeToolbarIfRequired() {    //  (Bug ID: #18)
        
        //	Getting all the sibling textFields.
        if let siblings = responderViews() {
            
            for view in siblings {
                
                if let toolbar = view.inputAccessoryView as? IQToolbar {

                    //setInputAccessoryView: check   (Bug ID: #307)
                    if view.responds(to: #selector(setter: UITextField.inputAccessoryView)) && (toolbar.tag == IQKeyboardManager.kIQDoneButtonToolbarTag || toolbar.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag) {
                        
                        if let textField = view as? UITextField {
                            textField.inputAccessoryView = nil
                        } else if let textView = view as? UITextView {
                            textView.inputAccessoryView = nil
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func _IQShowLog(_ logString: String) {
        
        #if IQKEYBOARDMANAGER_DEBUG
        println("IQKeyboardManager: " + logString)
        #endif
    }
}

