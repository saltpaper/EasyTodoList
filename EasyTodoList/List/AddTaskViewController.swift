//
//  AddTaskViewController.swift
//  EasyTodoList
//
//  Created by DJ on 13/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

final class AddTaskViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var isFinishButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var featureButton: UIButton!  // change tag color
    @IBOutlet weak var taskRemarkTextView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    var task: Task? // if task == nil : add new one; if task != nil: edit this one

    var selectedDate: Date! // store selected date on datepicker
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-times",target: self, selector: #selector(self.didClickCancelButton(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-check",target: self, selector: #selector(self.didClickDoneButton(sender:)))
        
        isFinishButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17.0)
        isFinishButton.setTitle(String.fontAwesomeIcon(code: "fa-square-o"), for: .normal)
        isFinishButton.setTitle(String.fontAwesomeIcon(code: "fa-check-square-o"), for: .selected)
        isFinishButton.setTitleColor(UIColor.extraDarkGreyColor(), for: .normal)
        isFinishButton.setTitleColor(UIColor.extraDarkGreyColor(), for: .selected)
        
        featureButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17.0)
        featureButton.setTitleColor(UIColor.textGreyColor(), for: .normal)
        featureButton.setTitle(String.fontAwesomeIcon(code: "fa-th-large"), for: .normal)
        
        taskTitleTextField.delegate = self
        taskTitleTextField.placeholder = "Title"

        datePicker = UIDatePicker.init()
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.date = NSDate() as Date
//        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: UIControlEvents.valueChanged)
        dateTextField.inputView = datePicker
        let toolBar = DHToolBar.initWithTarget(target: self, tag: 1001)
        toolBar.doneButton.action = #selector(self.didClickToolBarDoneButton)
        toolBar.cancelButton.action = #selector(self.didClickToolBarCancelButton)
        dateTextField.inputAccessoryView = toolBar
        
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _task = task {
            //edit task
            taskTitleTextField.text = _task.taskTitle
            dateTextField.text = (_task.taskDate as! Date).displayDate()
            selectedDate = _task.taskDate as Date!
             isFinishButton.isSelected = _task.isFinish
            
        }else {
            //create new task
            dateTextField.text = Date().displayDate()
            selectedDate = Date()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    //MARK:UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
//    func datePickerChanged(sender:UIDatePicker){
////        dateTextField.text = sender.date.displayDate()
////        selectedDate = sender.date
//    }
    
    
    @IBAction func didClickFinishButtonAction(_ sender: UIButton) {
         isFinishButton.isSelected = !sender.isSelected
    }
    
    //MARK: UIBarButtonItem action
    func didClickCancelButton(sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func didClickDoneButton(sender:UIBarButtonItem){
        //1. store new task on local
        let context = AppDelegate.sharedDelegate().persistentContainer.viewContext
        let task = Task(context: context)
        task.taskTitle = taskTitleTextField.text
        task.taskDate = selectedDate as NSDate?
        task.taskRemark = taskRemarkTextView.text
        task.createTime = NSDate()
        task.isFinish = isFinishButton.isSelected
        task.taskId = (NSDate() as Date).displayDate(dateFormat: dateWholeFormatter)
        //save data
        AppDelegate.sharedDelegate().saveContext()
        
        //2. upload to server 
        TodoListRetriever.uploadATaskToServer(taskItem: task, success: { (success) in
            // success
        }){ (error) in
            // failure -- need to show alertView with message: "sync failure"
        }        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:DHToolBar button action
    func didClickToolBarDoneButton() {
        dateTextField.text = datePicker.date.displayDate()
        selectedDate = datePicker.date
        dateTextField.resignFirstResponder()
    }
    
    func didClickToolBarCancelButton() {
        resignFirstResponder()
    }
    
}
