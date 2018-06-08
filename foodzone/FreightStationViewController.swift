//
//  ViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 23/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var imageLink: UITextView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var codeInfo: UILabel!
    @IBOutlet weak var foodGrade: UILabel!
    
    var session : AVCaptureSession!
    var video : AVCaptureVideoPreviewLayer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadImage(image : UIImage) -> String{
        let sasURL = "put SAS URL here"

        var error : NSError?
        var imageURL : String = ""
        
        let container = AZSCloudBlobContainer(url: URL(string: sasURL)!, error: &error)
        if error != nil {
            print("Error creating container object")
            return imageURL
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss-dd.MM.yyyy"
        let timestamp = formatter.string(from: date)
        
        imageURL = "https://foodzone.blob.core.windows.net/images/" + "image-\(timestamp).png"
        let blob = container.blockBlobReference(fromName: "image-\(timestamp).png")
        blob.properties.contentType = "image/png"
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))
        let imageData = UIImagePNGRepresentation(resizedImage)
        if imageData != nil {
            //activityIndicator.startAnimating()
            blob.upload(from: imageData!, completionHandler:{(NSError) -> Void in
                //self.activityIndicator.stopAnimating()
                self.foodGrade.text = "Grade I"
                print(NSError.debugDescription)
            })
        }
        
        return imageURL
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanCodeClicked(_ sender: Any) {
        session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch {
            print("Error in capture device")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video?.frame = view.layer.bounds
        view.layer.addSublayer(video!)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in UIPasteboard.general.string = object.stringValue
                        self.codeInfo.text = object.stringValue
                        self.session?.stopRunning()
                        self.video.removeFromSuperlayer()
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func submitInfoClicked(_ sender: Any) {
        //let imageURL = uploadImage(image: selectedImage.image!)
        //imageLink.text = imageURL
    }
    
    @IBAction func selectImageClicked(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select Picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action : UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2, y: 0, width: 1.0, height: 1.0)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
