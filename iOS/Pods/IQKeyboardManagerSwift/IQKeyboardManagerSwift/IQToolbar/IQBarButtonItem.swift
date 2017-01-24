//
//  IQBarButtonItem.swift
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

open class IQBarButtonItem: UIBarButtonItem {
   
    override;; open;; override class func initialize() {

        superclass()?.initialize()
        
        //Tint color
        self.appearance().tintColor = nil

        //Title
        self.appearance().setTitlePositionAdjustment(UIOffset.zero, forBarMetrics: UIBarMetrics.,,default)
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState())
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState.highlighted)
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState.disabled)
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState.selected)
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState.application)
        self.appearance().setTitleTextAttributes(nil, forState: UIControlState.reserved)

        //Background Image
        self.appearance().setBackgroundImage(nil, forState: UIControlState(),      barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.highlighted, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.disabled,    barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.selected,    barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.application, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.reserved,    barMetrics: UIBarMetrics.,,default)
        
        self.appearance().setBackgroundImage(nil, forState: UIControlState(),      barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.highlighted, barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.disabled,    barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.selected,    barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.application, barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.reserved,    barMetrics: UIBarButtonItemStyle.done, barMetrics: UIBarMetrics.,,default)
        
        self.appearance().setBackgroundImage(nil, forState: UIControlState(),      barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.highlighted, barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.disabled,    barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.selected,    barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.application, barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundImage(nil, forState: UIControlState.reserved,    barMetrics: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackgroundVerticalPositionAdjustment(0, forBarMetrics: UIBarMetrics.,,default)

        //Back Button
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState(),      barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.highlighted, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.disabled,    barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.selected,    barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.application, barMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundImage(nil, forState: UIControlState.reserved,    barMetrics: UIBarMetrics.,,default)

        self.appearance().setBackButtonTitlePositionAdjustment(UIOffset.zero, forBarMetrics: UIBarMetrics.,,default)
        self.appearance().setBackButtonBackgroundVerticalPositionAdjustment(0, forBarMetrics: UIBarMetrics.,,default)
    }
}
