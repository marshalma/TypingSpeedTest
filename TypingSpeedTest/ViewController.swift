//
//  ViewController.swift
//  TypingSpeedTest
//
//  Created by 马朔 on 15/5/3.
//  Copyright (c) 2015年 马朔. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.editable = false
        self.clearAll()
    }
    
    override func viewWillAppear() {
        
        self.view.window!.opaque = false
//        self.buildInTextField!.opaque = false
//        self.userTextField!.opaque = false
        
        println(self.view.window!.backgroundColor! = NSColor(calibratedRed: 1.0*0.9, green: 0.98*0.9, blue: 0.89*0.9, alpha: 0.99))
        self.buildInTextField.textColor! = NSColor(calibratedRed: 41.0/255.0, green: 66.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        self.userTextField.textColor! = NSColor(calibratedRed: 185.0/255.0, green: 65.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    var timer : NSTimer? = nil
    var userInTyping = false
    var timeTotalUsed = 0 // as 0.1 second
    var totalMistypedChar = 0
    var standardTextString:String {
        get{
            return buildInTextField.stringValue
        }
    }
    var userTypedTextString:String {
        get{
            return userTextField.stringValue
        }
        set{
            userTextField.stringValue = newValue

        }
    }
    var totalTimeConsumedString:String {
        
        get{
            return ""
        }
        
        set{
            totalTime.stringValue = newValue + "s"
        }
    }
    var correctCharString:String {
        
        get{
            return ""
        }
        
        set{
            correctChar.stringValue = newValue
        }
    }
    var totalCharString:String {
        get{
            return totalChar.stringValue
        }
        
        set{
            totalChar.stringValue = newValue
        }
    }
    var wpmString:String {
        get{
            return ""
        }
        
        set{
            wpm.stringValue = newValue
        }
    }
    var accuracyString:String {
        get{
            return ""
        }
        
        set{
            accuracy.stringValue = newValue + "%"
        }
    }
    
    @IBOutlet weak var totalTime: NSTextField!
    @IBOutlet weak var correctChar: NSTextField!
    @IBOutlet weak var totalChar: NSTextField!
    @IBOutlet weak var wpm: NSTextField!
    @IBOutlet weak var accuracy: NSTextField!
    @IBOutlet weak var buildInTextField: NSTextField!
    @IBOutlet weak var userTextField: NSTextField!
    @IBOutlet var mainView: NSView!
    
    
    
    
    
    func timerFireFunction() {
        
        self.timeTotalUsed += 1
        
        self.totalTimeConsumedString = String(format: "%.1f" ,Double(timeTotalUsed)/10.0)
        
    }

    
    // clear user textfield and
    func clearAll() {
        
        self.timeTotalUsed = 0
        self.totalMistypedChar = 0
        self.totalTimeConsumedString = "0.0"
        self.correctCharString = ""
        self.totalCharString = String(count(standardTextString))
        self.userTypedTextString = ""
        
    }
    
    override func keyDown(event: NSEvent) {
        
        if (!self.userInTyping) {
            
            return
            
        }
        
        if let char = event.characters {
            //print(event)
            
            if (event.keyCode == 51) && (!userTypedTextString.isEmpty) {
                
                var userString = userTypedTextString
                userString.removeAtIndex(userString.endIndex.predecessor())
                userTypedTextString = userString
                
            }
            else if(event.keyCode == 51){
                
            }
            else{
                userTypedTextString += char
                
                var typeCharAsStr = userTypedTextString.substringWithRange(userTypedTextString.endIndex.predecessor()..<userTypedTextString.endIndex)
                var stdCharAsStr = standardTextString.substringWithRange(userTypedTextString.endIndex.predecessor()..<userTypedTextString.endIndex)
                //println(stdCharAsStr + "vs" + typeCharAsStr)
                if (typeCharAsStr != stdCharAsStr){
                    totalMistypedChar += 1
                    //println(totalMistypedChar)
                }
            }
        }
        
        
        //see if user have finished typing
        if (count(standardTextString) == count(userTypedTextString)){
            
            stopTyping()
            
            self.userInTyping = false
            
        }
    }
    
    func stopTyping() {
        
        timer?.invalidate()
        
        totalTimeConsumedString = String(format: "%.1f", Double(timeTotalUsed)/10.0)
        
        if let totalCharInt = totalCharString.toInt() {
            
            wpmString = String(format: "%.1f", Double(totalCharInt)*120.0/Double(timeTotalUsed))
            
            correctCharString = String((totalCharInt - totalMistypedChar)>0 ? (totalCharInt - totalMistypedChar) : 0)
            
            let rawAccuracy = Double(totalCharInt - totalMistypedChar)/Double(totalCharInt)
            
            accuracyString = String(format: "%.1f", rawAccuracy>0 ? rawAccuracy*100 : 0.0)
            
        }
        
    }

    
    
    
    @IBAction func startTyping(sender: NSButton) {
        
        self.clearAll()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("timerFireFunction"), userInfo: nil, repeats: true)
        
        self.userInTyping = true
        
    }

    @IBAction func stopTyping(sender: NSButton) {
        
        self.timer?.invalidate()
        
        self.clearAll()
        
        self.userInTyping = false
        
    }
    
}

