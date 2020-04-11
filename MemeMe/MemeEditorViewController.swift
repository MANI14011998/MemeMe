//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by MANINDER SINGH on 05/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottumTextField: UITextField!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBat: UIToolbar!
    
    var memedImage: UIImage!
       
    override func viewDidLoad() {
        super.viewDidLoad()
       // setTextFields(textInput: topTextField, defaultText: "TOP")
       // setTextFields(textInput: bottumTextField, defaultText: "BOTTOM")


    }
   
    
    func pickImage(type:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(type: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(type: .camera)
    }
    
    @IBAction func shareItems(sender: AnyObject) {
        
        let memeToShare = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.safelySaveMeme(memedImage: memeToShare)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: cancel image selection
    @IBAction func cancelMainScreen(sender: AnyObject) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottumTextField.text = "BOTTOM"
        dismiss(animated: true, completion: {}) // removed self
    }
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imagePickerView.image = image
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){

        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           
           textField.resignFirstResponder()
           
           return true
       }
    
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if(bottumTextField.isEditing){

        view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(
        _ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                view.frame.origin.y = 0
            }
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        view.endEditing(true)   // removed self
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setTextFields(textInput: UITextField!, defaultText: String) {
           let memeTextAttributes = [
               NSAttributedString.Key.strokeColor : UIColor.black,
               NSAttributedString.Key.foregroundColor : UIColor.white,
               NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
               NSAttributedString.Key.strokeWidth : -3.0 ] as [NSAttributedString.Key : Any]
           textInput.text = defaultText
           textInput.defaultTextAttributes = memeTextAttributes
           textInput.delegate = self
           textInput.textAlignment = .center
       }
    override func viewWillAppear(_ animated: Bool) {
         subscribeToKeyboardNotifications()
         setTextFields(textInput: topTextField, defaultText: "TOP")
         setTextFields(textInput: bottumTextField, defaultText: "BOTTOM")
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
   
    func generateMemedImage() -> UIImage {
        
        toolBarVisible(visible: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBarVisible(visible: true)
        
        return memedImage
    }
    func safelySaveMeme(memedImage: UIImage) {
        // safely unwrap optionals
        if imagePickerView.image != nil && topTextField.text != nil && bottumTextField.text != nil
        {
            let top = self.topTextField.text!
            let bottom = self.bottumTextField.text!
            let image = self.imagePickerView.image!
            
            let meme = Meme(originalImage: image, bottomText: bottom, topText: top, memeImage: memedImage)
            
            MemeStorage.memes.append(meme)
        }
    }
    
    // MARK: toolbar functions
    func toolBarVisible(visible: Bool){
        if !visible {
            navBar.isHidden = true
            toolBat.isHidden = true
        } else {
            navBar.isHidden = false
            toolBat.isHidden = false 
        }
    }
    
     func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
    
    
}

