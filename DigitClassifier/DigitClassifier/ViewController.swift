//
//  ViewController.swift
//  DigitClassifier
//
//  Created by Gokul Swamy on 4/18/18.
//  Copyright © 2018 Gokul Swamy. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var drawPad: DrawPadView!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var labelInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelInput.delegate = self
        //self.sendImageToServer(name: "2.png", address: "http://10.142.5.22:8000")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Code modified from https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-uiimagepngrepresentation
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func classify(_ sender: Any) {
        // TODO
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
       // TODO
    }
    
    @IBAction func save(_ sender: Any) {
        // TODO
    }
    
    func getImage(name: String) -> UIImage? {
        // TODO
        return nil
    }
    
    // Copied from https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // TODO
        return UIImage()
    }
    
    // Code from https://gist.github.com/gkswamy98/425586a8223ff3a3c9363c37ed8fe10c
    func sendImageToServer(name: String, address: String){
        // TODO
    }
    
    
    
}

