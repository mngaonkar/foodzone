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

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var codeInfo: UILabel!
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
    
    func uploadImage(image : UIImage) {
        let sasURL = "https://foodzone.blob.core.windows.net/images?sv=2017-07-29&ss=bfqt&srt=sco&sp=rwdlacup&se=2018-04-24T03:49:50Z&st=2018-04-23T19:49:50Z&spr=https&sig=74gYzNMEsSrkVeJJU2lB9eDwwVKpRf6BIw8xjh0V5KY%3D"

        var error : NSError?
        
        let container = AZSCloudBlobContainer(url: URL(string: sasURL)!, error: &error)
        if error != nil {
            print("Error creating container object")
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss-dd.MM.yyyy"
        let timestamp = formatter.string(from: date)
        
        let blob = container.blockBlobReference(fromName: "image-\(timestamp).png")
        blob.properties.contentType = "image/png"
        
        let imageData = UIImagePNGRepresentation(image)
        if imageData != nil {
            self.activityIndicator.startAnimating()
            blob.upload(from: imageData!, completionHandler:{(NSError) -> Void in
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    @IBAction func scanCodeClicked(_ sender: Any) {
        session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch {
            print("Error in capture device")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video?.frame = view.layer.bounds
        view.layer.addSublayer(video!)
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObjectTypeQRCode {
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
        uploadImage(image: selectedImage.image!)
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
