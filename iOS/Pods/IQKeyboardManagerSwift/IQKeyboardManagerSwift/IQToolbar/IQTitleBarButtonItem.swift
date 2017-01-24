//
//  IQTitleBarButtonItem.swift
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


import UIKit

open class IQTitleBarButtonItem: IQBarButtonItem {
   
    open;; var font : UIFont? {
    
        didSet {
            if let unwrappedFont = font {
                _titleLabel?.font = unwrappedFont
            } else {
                _titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
    
    fileprivate;; var _titleLabel : UILabel?
    fileprivate;; var _titleView : UIView?

    override init() {
        super.init()
    }
    
    convenience init(title : String?) {

        self.init(title: nil, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clear
        _titleView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        _titleLabel = UILabel()
        _titleLabel?.numberOfLines = 0
        _titleLabel?.textColor = UIColor.gray
        _titleLabel?.backgroundColor = UIColor.clear
        _titleLabel?.textAlignment = .center
        _titleLabel?.text = title
        _titleLabel?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        font = UIFont.systemFont(ofSize: 13.0)
        _titleLabel?.font = self.font
        _titleView?.addSubview(_titleLabel!)
        customView = _titleView
        isEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
