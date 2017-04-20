//
//  ViewController.swift
//  imageQuality
//
//  Created by Alejandro Delgado Diaz on 18/04/2017.
//  Copyright © 2017 adelgadodiaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    @IBAction func resizePhoto(_ sender: Any) {
        let size = CGSize(width: 50, height: 50)

        imageView.image = imageView.image?.scaleImage(toSize: size)
        printImageSize(imageView.image!)
    }
    
    func printImageSize(_ image: UIImage) {
       
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let imageSize: Float = Float(imgData.length)
        print("size of image in KB: %f ", imageSize / 1024.0)
    }

    
    @IBAction func photoFromLibrary(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        printImageSize(chosenImage)
        dismiss(animated:true, completion: nil) //5
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    
}

extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}

