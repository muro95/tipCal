//
//  AppDelegate.swift
//  Tip Cal
//
//  Created by Alex Truong on 3/30/21.
//  Copyright © 2021 Alex Truong. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var defaultTipLabel: UILabel!
  @IBOutlet weak var animationsLabel: UILabel!
  @IBOutlet weak var defaultTipfield: UITextField!
  @IBOutlet weak var animationSwitch: UISwitch!
  @IBOutlet weak var historyLabel: UIButton!
  
  var animateOn: Bool = true
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Settings"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    

    defaultTipfield.layer.cornerRadius = 10.0
    defaultTipfield.clipsToBounds = true
    
    defaultTipfield.text = String(defaults.integer(forKey:
      "defaultTipPercent")) + "%"
    animateOn = defaults.bool(forKey: "animateOn")

    
    if animateOn {
      defaultTipLabel.center.y -= view.bounds.width
      animationsLabel.center.x -= view.bounds.width
      
      defaultTipfield.center.y -= view.bounds.width
      historyLabel.center.y += view.bounds.width
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if animateOn {
      UIView.animate(withDuration: 0.2, delay: 0.0,
                     options: [.curveEaseInOut], animations: {
        self.defaultTipLabel.center.y += self.view.bounds.width
        self.defaultTipfield.center.y += self.view.bounds.width

        self.animationsLabel.center.x += self.view.bounds.width
        self.historyLabel.center.y -= self.view.bounds.width
      })
    }
  }
  
  @IBAction func clearTip(_ sender: Any) {
    defaultTipfield.placeholder = "%"
    defaultTipfield.becomeFirstResponder()
  }
  
  
  @IBAction func onTap(_ sender: Any) {
    defaultTipfield.endEditing(true)
    defaultTipfield.text = String(defaults.integer(forKey:
      "defaultTipPercent")) + "%"
  }
  
  @IBAction func deleteHistory(_ sender: Any) {
    let delete = UIAlertController(title: "Delete History", message:
      "All saved entried will be deleted.", preferredStyle:
      UIAlertControllerStyle.alert)
    delete.addAction(UIAlertAction(title: "Ok", style: .default, handler:
      { (action: UIAlertAction!) in
      for index in 1...5 {
        let key = "history" + String(index)
        self.defaults.set(0.0, forKey: key)
      }
      self.defaults.set(0.0, forKey: "storedBill")
      self.defaults.set(0.0, forKey: "storedTipAmount")
      self.defaults.set(0.0, forKey: "storedTotal")
      self.defaults.set(0, forKey: "implicitTipRate")
      self.defaults.set(1, forKey: "historyPosition")
      self.defaults.set(0.0, forKey: "twoLabel")
      self.defaults.set(0.0, forKey: "threeLabel")
      self.defaults.set(0.0, forKey: "fourLabel")
      self.defaults.set(0.0, forKey: "fiveLabel")
      self.defaults.synchronize()
    }))
    delete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
      { (action: UIAlertAction!) in
    }))
    present(delete, animated: true, completion: nil)
  }
  
  
  @IBAction func saveDefaultTip(_ sender: Any) {
    let tipPercent = Int(defaultTipfield.text!) ?? defaults.integer(forKey:
      "defaultTipPercent")
    defaults.set(tipPercent, forKey: "defaultTipPercent")
    let bill = defaults.double(forKey: "storedBill")
    let taxRate = defaults.double(forKey: "defaultTax") / 100
    let tax = bill * taxRate
    let tipAmount = (bill + tax) * ((Double(defaults.integer(forKey: 
      "defaultTipPercent"))) / 100.0)
    defaults.set(tipAmount, forKey: "storedTipAmount")
    defaults.synchronize()
  }
}
