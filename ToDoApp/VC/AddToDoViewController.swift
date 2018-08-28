import UIKit
import CoreData

class AddToDoViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }

    @IBAction func done(_ sender: UIButton) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error saving todo: \(error)")
        }
    }
    
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: .UIKeyboardWillShow, object: nil)
        
        textView.becomeFirstResponder()
        
        if let todo = todo {
            textView.text = todo.title
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
}


extension AddToDoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}




















