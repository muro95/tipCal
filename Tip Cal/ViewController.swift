//
//  AppDelegate.swift
//  Tip Cal
//
//  Created by Alex Truong on 3/30/21.
//  Copyright © 2021 Alex Truong. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var shareView: UIView!
  @IBOutlet weak var historyView: UIView!
  @IBOutlet weak var totalName: UILabel!
  @IBOutlet weak var tipName: UILabel!
  @IBOutlet weak var billAmount: UITextField!
  @IBOutlet weak var tipField: UITextField!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var viewBar: UIView!
  @IBOutlet weak var twoLabel: UILabel!
  @IBOutlet weak var threeLabel: UILabel!
  @IBOutlet weak var fourLabel: UILabel!
  @IBOutlet weak var fiveLabel: UILabel!
  @IBOutlet weak var historyOne: UILabel!
  @IBOutlet weak var historyTwo: UILabel!
  @IBOutlet weak var historyThree: UILabel!
  @IBOutlet weak var historyFour: UILabel!
  @IBOutlet weak var historyFive: UILabel!

  
  var animateOn: Bool = true
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let storedDate = defaults.double(forKey: "storedDate")
    let currentDate = Date().timeIntervalSince1970
    if (currentDate - storedDate >= 600.0) {
      defaults.set(0.00, forKey: "storedBill")
      defaults.set(0.00, forKey: "storedTipAmount")
    }
    defaults.set(Date().timeIntervalSince1970, forKey: "storedDate")
    
    let defaultAnimateObject = defaults.object(forKey: "animateOn")
    let defaultTipPctObject = defaults.object(forKey: "defaultTipPercent")
    let defaultBillObject = defaults.object(forKey: "storedBill")
    let defaultTotalObject = defaults.object(forKey: "storedTotal")
    let defaultTipAmtObject = defaults.object(forKey: "storedTipAmount")
    let defaultImplicitTipRateObject = defaults.object(forKey: "implicitTipRate")
    let defaultHistoryPosition = defaults.object(forKey: "historyPosition")
    let defaultTwoLabel = defaults.object(forKey: "twoLabel")
    let defaultThreeLabel = defaults.object(forKey: "threeLabel")
    let defaultFourLabel = defaults.object(forKey: "fourLabel")
    let defaultFiveLabel = defaults.object(forKey: "fiveLabel")
    for index in 1...5 {
      let key = "history" + String(index)
      let history = defaults.object(forKey: key)
      if history == nil {
        defaults.set(0.0, forKey: key)
      }
    }
    if defaultAnimateObject == nil {
      defaults.set(true, forKey: "animateOn")
    }

    if defaultTwoLabel == nil {
      defaults.set(0.0, forKey: "twoLabel")
    }
    if defaultThreeLabel == nil {
      defaults.set(0.0, forKey: "threeLabel")
    }
    if defaultFourLabel == nil {
      defaults.set(0.0, forKey: "fourLabel")
    }
    if defaultFiveLabel == nil {
      defaults.set(0.0, forKey: "fiveLabel")
    }
    if defaultTipPctObject == nil {
      defaults.set(15, forKey: "defaultTipPercent")
    }

    if defaultTipAmtObject == nil {
      defaults.set(0.00, forKey: "storedTipAmount")
    }
    if defaultBillObject == nil {
      defaults.set(0.00, forKey: "storedBill")
    }
    if defaultTotalObject == nil {
      defaults.set(0.00, forKey: "storedTotal")
    }
    if defaultImplicitTipRateObject == nil {
      defaults.set(0, forKey: "implicitTipRate")
    }
    if defaultHistoryPosition == nil {
      defaults.set(1, forKey: "historyPosition")
    }
    defaults.synchronize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    billAmount.layer.cornerRadius = 10.0
    billAmount.clipsToBounds = true
    viewBar.layer.cornerRadius = 10.0
    viewBar.clipsToBounds = true
    tipField.layer.cornerRadius = 10.0
    tipField.clipsToBounds = true
    shareView.layer.cornerRadius = 10.0
    shareView.clipsToBounds = true
    historyView.layer.cornerRadius = 10.0
    historyView.clipsToBounds = true
    
        animateOn = defaults.bool(forKey: "animateOn")

    
    clearBillAmount(self)
    
    if animateOn {
      tipName.center.x -= view.bounds.width
      totalName.center.x -= view.bounds.width
      
      tipField.center.x += view.bounds.width
      totalLabel.center.x += view.bounds.width
      
      billAmount.center.y -= view.bounds.width
      tipControl.center.y += view.bounds.height
      self.viewBar.alpha = 0
    }
    inputTip(self)
    updateHistory(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if animateOn {
      UIView.animate(withDuration: 0.2, delay: 0.05, options:
        [.curveEaseInOut], animations: {
        self.billAmount.center.y += self.view.bounds.width
      })
      UIView.animate(withDuration: 0.2, delay: 0.05, options:
        [.curveEaseInOut], animations: {
        self.tipName.center.x += self.view.bounds.width
        self.tipField.center.x -= self.view.bounds.width
        self.totalName.center.x += self.view.bounds.width
        self.totalLabel.center.x -= self.view.bounds.width
        self.tipControl.center.y -= self.view.bounds.height
      })
      UIView.animate(withDuration: 0.2, delay: 0.15, options:
        [.curveEaseInOut], animations: {
        self.viewBar.alpha = 1
      })
    }
  }
  
  @IBAction func clearBillAmount(_ sender: Any) {
    billAmount.text = ""
    billAmount.placeholder = NumberFormatter().currencySymbol
    billAmount.becomeFirstResponder()
  }
  
  @IBAction func clearTipField(_ sender: Any) {
    tipField.placeholder = NumberFormatter().currencySymbol
    tipField.becomeFirstResponder()
  }
  
  @IBAction func onTap(_ sender: Any) {
    billAmount.endEditing(true)
    tipField.endEditing(true)
    view.endEditing(true)
    billAmount.text = formatOutput(defaults.double(forKey: "storedBill"))
  }
  
  @IBAction func saveTotal(_ sender: Any) {
    // Save total to next position in default list
    let position = defaults.integer(forKey: "historyPosition")
    let key = "history" + String(position)
    let total = defaults.double(forKey: "storedTotal")
    defaults.set(total, forKey: key)
    let newPosition = (position == 5) ? 1 : (position + 1)
    defaults.set(newPosition, forKey: "historyPosition")
    defaults.synchronize()
    updateHistory(self)
  }
  
  
  func updateHistory(_ sender: Any) {
    historyOne.text = formatOutput(defaults.double(forKey: "history1"))
    historyTwo.text = formatOutput(defaults.double(forKey: "history2"))
    historyThree.text = formatOutput(defaults.double(forKey: "history3"))
    historyFour.text = formatOutput(defaults.double(forKey: "history4"))
    historyFive.text = formatOutput(defaults.double(forKey: "history5"))
    twoLabel.text = formatOutput(defaults.double(forKey: "twoLabel"))
    threeLabel.text = formatOutput(defaults.double(forKey: "threeLabel"))
    fourLabel.text = formatOutput(defaults.double(forKey: "fourLabel"))
    fiveLabel.text = formatOutput(defaults.double(forKey: "fiveLabel"))
  }
  
  @IBAction func calculateTip(_ sender: Any) {
    let tipBar = [0.18, 0.2, 0.25]
    let tipPercent = (tipControl.selectedSegmentIndex != -1) ?
      tipBar[tipControl.selectedSegmentIndex] :
      Double(defaults.integer(forKey: "defaultTipPercent")) / 100.0
    let bill = defaults.double(forKey: "storedBill")
    let tip = (bill) * tipPercent
    defaults.set(tip, forKey: "storedTipAmount")
    defaults.synchronize()
    calculateTotal(self)
  }
  
  @IBAction func inputTip(_ sender: Any) {
    let tip = Double(tipField.text!) ?? defaults.double(forKey: "storedTipAmount")
    defaults.set(tip, forKey: "storedTipAmount")
    defaults.synchronize()
    calculateTotal(self)
  }
  
  @IBAction func inputBill(_ sender: Any) {
    let bill = Double(billAmount.text!) ?? defaults.double(forKey: "storedBill")
    defaults.set(bill, forKey: "storedBill")
    defaults.synchronize()
    calculateTip(self)
  }
  
  func formatOutput(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    let formattedOutput = formatter.string(from: amount as NSNumber)
    return formattedOutput!
  }
  
  func calculateTotal(_ sender: Any) {
    let bill = defaults.double(forKey: "storedBill")
    let tip = defaults.double(forKey: "storedTipAmount")
    var implicitTipRate = defaults.integer(forKey: "implicitTipRate")
    let total = bill + tip
    defaults.set(total, forKey: "storedTotal")
    if (bill > 0.0) {
      implicitTipRate = Int((tip / bill) * 100.0)
      defaults.set((total / 2.0), forKey: "twoLabel")
      defaults.set((total / 3.0), forKey: "threeLabel")
      defaults.set((total / 4.0), forKey: "fourLabel")
      defaults.set((total / 5.0), forKey: "fiveLabel")
    } else {
      implicitTipRate = 0
    }
    defaults.set(implicitTipRate, forKey: "implicitTipRate")
    defaults.synchronize()
    tipName.text = "Tip (" + String(implicitTipRate) + "%)"
    tipField.text = formatOutput(tip)
    totalLabel.text = formatOutput(total)
    twoLabel.text = formatOutput(defaults.double(forKey: "twoLabel"))
    threeLabel.text = formatOutput(defaults.double(forKey: "threeLabel"))
    fourLabel.text = formatOutput(defaults.double(forKey: "fourLabel"))
    fiveLabel.text = formatOutput(defaults.double(forKey: "fiveLabel"))
  }
}
