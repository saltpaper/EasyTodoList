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

final class AddTaskViewController: UIViewController,UITextFieldDelegate,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var isFinishButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var featureButton: UIButton!  // change tag color
    @IBOutlet weak var taskRemarkTextView: UITextView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    var task: Task? // if task == nil : add new one; if task != nil: edit this one

    var selectedDate: Date! // store selected date on datepicker
    var datePicker: UIDatePicker!
    
    var selectedTagColor:String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        taskTitleTextField.placeholder = NSLocalizedString("Todo.task_title", comment: "Title")

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
            taskRemarkTextView.text = _task.taskRemark
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-chevron-left",target: self, selector: #selector(self.didClickBackButton(sender:)))
            
            if let _selectedColor = _task.tagColor {
                featureButton.setTitleColor(UIColor.init(rgba: _selectedColor), for: .normal)
                selectedTagColor = _selectedColor
            }

        }else {
            //create new task
            dateTextField.text = Date().displayDate()
            selectedDate = Date()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-times",target: self, selector: #selector(self.didClickCancelButton(sender:)))
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
    
    @IBAction func didClickFeatureButtonAction(_ sender: UIButton) {
        let featureVC = FeatureViewController()
        featureVC.modalPresentationStyle = UIModalPresentationStyle.custom
        featureVC.transitioningDelegate = self
        featureVC.selectedColorBlock = ({[unowned self](colorString) in
            self.selectedTagColor = colorString
            sender.setTitleColor(UIColor.init(rgba: colorString), for: .normal)
        })
        
        featureVC.selectedColor = selectedTagColor
        self.present(featureVC, animated: true, completion: nil)
    }
    
    
    //MARK: UIBarButtonItem action
    func didClickCancelButton(sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func didClickBackButton(sender:UIBarButtonItem){
        _ = self.navigationController?.popViewController(animated: true)
    }

    func didClickDoneButton(sender:UIBarButtonItem){
        let context = AppDelegate.sharedDelegate().persistentContainer.viewContext

        if let _task = task,let tempTask = context.object(with: _task.objectID) as? Task {
            // Edit task
            self.configureTaskField(task: tempTask)

            //save data
            AppDelegate.sharedDelegate().saveContext()

            // call server
            TodoListRetriever.editTaskToServer(taskId: _task.taskId!, taskItem: tempTask.transformToDic(), success: { (success) in
                // success
                //_ = self.navigationController?.popViewController(animated: true)
            }){ (error) in
                // failure -- need to show alertView with message: "sync failure"
                //display alert
                let alert = UIAlertController(title: NSLocalizedString("app.warning", comment: "Warning"), message: "server failure", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("app.cancel", comment: "Cancel"), style: .cancel, handler: { (action) -> Void in

                }))

                self.present(alert, animated: true, completion: nil)
            }
            
            _ = self.navigationController?.popViewController(animated: true)

 
        }else {
            // Create new task
            //1. store new task on local
            let newTask = Task(context: context)
            self.configureTaskField(task: newTask)
            newTask.createTime = NSDate()
            newTask.taskId = (NSDate() as Date).displayDate(dateFormat: TODO_Constant.dateWholeFormatter)

            //save data
            AppDelegate.sharedDelegate().saveContext()
            
            //2. upload to server
            TodoListRetriever.uploadATaskToServer(taskItem: newTask, success: { (success) in
                // success
            }){ (error) in
                // failure -- need to show alertView with message: "sync failure"
            }
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    func configureTaskField(task:Task,isEdit:Bool = false){
        
        task.taskTitle = taskTitleTextField.text
        task.taskDate = selectedDate as NSDate?
        task.taskRemark = taskRemarkTextView.text
        task.isFinish = isFinishButton.isSelected
        if let _selectedColor = selectedTagColor {
            task.tagColor = _selectedColor
        }
        
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimationTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimationTransition()
    }
    
    
}
