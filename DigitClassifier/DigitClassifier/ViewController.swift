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
        let model = mnistCNN()
        if let image = drawPad.image{
            let resized = self.resizeImage(image: image, targetSize: CGSize(width: 28, height: 28))
            let prediction = try? model.prediction(image: resized.pixelBuffer()!).classLabel
            guessLabel.text = prediction
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.drawPad.image = nil
            self.guessLabel.text = "#"
        })
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        let id: String = (UIDevice.current.identifierForVendor?.uuidString)!
        let text = labelInput.text
        if let unwrapped = text {
            if unwrapped.count == 1 {
                if let image = drawPad.image{
                    let resized = self.resizeImage(image: image, targetSize: CGSize(width: 28, height: 28))
                    let imageData = UIImageJPEGRepresentation(resized, 1.0)
                    let strBase64: String = (imageData?.base64EncodedString(options: .lineLength64Characters))!
                    let label = unwrapped
                    let body = ["img": strBase64, "label": label, "id": id]
                    do{
                        let json = try (JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted))
                        var request = URLRequest(url: URL(string: "http://10.142.5.22:8000")!)
                        //App Transport Security blocks http:// connections, disable if needed
                        request.httpMethod = "POST" //"GET", ...
                        request.httpBody = json
                        request.addValue("value", forHTTPHeaderField: "header")
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if error != nil {
                                //Your HTTP request failed.
                                print(error?.localizedDescription)
                            } else {
                                //Your HTTP request succeeded
                                print(String(data: data!, encoding: String.Encoding.utf8))
                            }
                            }.resume()
                    }
                    catch {
                        print("incompatable body")
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please label with exactly one digit", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        // Code From https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-uiimagepngrepresentation
        let text = labelInput.text
        if let unwrapped = text {
            if unwrapped.count == 1 {
                if let image = drawPad.image{
                    let resized = self.resizeImage(image: image, targetSize: CGSize(width: 28, height: 28))
                    if let data = UIImagePNGRepresentation(resized){
                        let filename = getDocumentsDirectory().appendingPathComponent(unwrapped + ".png")
                        try? data.write(to: filename)
                    }
                }
                drawPad.image = nil
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Please label with exactly one digit", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getImage(name: String) -> UIImage? {
        // Code modified from https://stackoverflow.com/questions/29005381/get-image-from-documents-directory-swift
        var image: UIImage? = nil
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            image = UIImage(contentsOfFile: imageURL.path)
        }
        return image
    }
    
    // Copied from https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // Code from https://gist.github.com/gkswamy98/425586a8223ff3a3c9363c37ed8fe10c
    func sendImageToServer(name: String, address: String){
        let id: String = (UIDevice.current.identifierForVendor?.uuidString)!
        let image = self.getImage(name: name)
        let imageData = UIImageJPEGRepresentation(image!, 1.0)
        let strBase64: String = (imageData?.base64EncodedString(options: .lineLength64Characters))!
        let label = String(name[name.startIndex])
        let body = ["img": strBase64, "label": label, "id": id]
        do{
            let json = try (JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted))
            var request = URLRequest(url: URL(string:address)!)
            //App Transport Security blocks http:// connections, disable if needed
            request.httpMethod = "POST" //"GET", ...
            request.httpBody = json
            request.addValue("value", forHTTPHeaderField: "header")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    //Your HTTP request failed.
                    print(error?.localizedDescription)
                } else {
                    //Your HTTP request succeeded
                    print(String(data: data!, encoding: String.Encoding.utf8))
                }
                }.resume()
        }
        catch {
            print("incompatable body")
        }
    }
    
    
    
}

