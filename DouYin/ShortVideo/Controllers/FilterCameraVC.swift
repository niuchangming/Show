//
//  FilterCameraVC.swift
//  DouYin
//
//  Created by Niu Changming on 12/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import GPUImage
import KeyframePicker

let blendImageName = "login_bg.jpg"
let tmpFilename = "tmpfile.mp4"
let maxSeconds: CGFloat = 15

class FilterCameraVC: UIViewController {
    @IBOutlet weak var renderView: RenderView!{
        didSet{
            renderView.fillMode = .preserveAspectRatioAndFill
        }
    }
    @IBOutlet weak var recordBtn: UIButton!{
        didSet{
            recordBtn.isHidden = false
        }
    }
    @IBOutlet weak var stopBtn: UIButton!{
        didSet{
            stopBtn.isHidden = true
        }
    }
    
    @IBOutlet weak var okBtn: UIButton!{
        didSet{
            okBtn.isHidden = true
        }
    }
    @IBOutlet weak var reRecordBtn: UIButton!{
        didSet{
            reRecordBtn.isHidden = true
        }
    }
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var beautyBarView: BeautyBarView!
    @IBOutlet weak var beautyBarBottomContraint: NSLayoutConstraint!
    var videoCamera:Camera?
    var isRecording = false
    var isFinished = false
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    var movieOutput:MovieOutput? = nil
    var blendImage:PictureInput?
    var fileUrl: URL?
    var currentFilter: FilterOperationInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            videoCamera = try Camera(sessionPreset:.vga640x480, location:.backFacing)
            videoCamera!.runBenchmark = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
    
        self.beautyBarView.delegate = self
        self.currentFilter = filterOperations[0];
        self.currentFilter?.updateBasedOnSliderValue(Float(0.8))
        self.beautyBarBottomContraint.constant = self.beautyBarView.frame.size.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideBeautyBar))
        renderView.addGestureRecognizer(tapGestureRecognizer)
        
        self.configureView()
    }

    func configureView() {
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        if let filterConfig = self.currentFilter {
            self.title = filterConfig.titleName
            
            if let view = self.renderView {
                switch filterConfig.filterOperationType {
                case .singleInput:
                    videoCamera.addTarget(filterConfig.filter)
                    filterConfig.filter.addTarget(view)
                case .blend:
                    videoCamera.addTarget(filterConfig.filter)
                    self.blendImage = PictureInput(imageName:blendImageName)
                    self.blendImage?.addTarget(filterConfig.filter)
                    self.blendImage?.processImage()
                    filterConfig.filter.addTarget(view)
                case let .custom(filterSetupFunction:setupFunction):
                    filterConfig.configureCustomFilter(setupFunction(videoCamera, filterConfig.filter, view))
                }
                
                videoCamera.startCapture()
            }

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopCamera()
        super.viewWillDisappear(animated)
    }
 
    func stopCamera(){
        if let videoCamera = videoCamera {
            videoCamera.stopCapture()
            videoCamera.removeAllTargets()
            blendImage?.removeAllTargets()
        }
    }
    
    @IBAction func musicBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func beautyBtnClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.beautyBarBottomContraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    @objc func updateProgress() {
        progress = progress + (CGFloat(0.05) / maxSeconds)
        self.progressBar.setProgress(Float(progress), animated: true)
 
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
    func startProgress(){
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(FilterCameraVC.updateProgress), userInfo: nil, repeats: true)
    }
    
    @IBAction func recordBtnClicked(_ sender: Any) {
        if (!isRecording) {
            do {
                let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
                self.fileUrl = URL(string: tmpFilename, relativeTo:documentsDir)!
                do {
                    removeTmpFile(fileUrl: self.fileUrl!)
                    
                    self.isRecording = true
                    self.isFinished = false
                    self.movieOutput = try MovieOutput(URL: self.fileUrl!, size:Size(width:480, height:640), liveVideo:true)
                    self.videoCamera?.audioEncodingTarget = self.movieOutput
                    (currentFilter?.filter)! --> movieOutput!
                    
                    movieOutput!.startRecording()
                    self.updateButtonAppear()
                    self.startProgress()
                } catch {
                    print("File cannot be create !")
                }
            } catch {
                fatalError("Couldn't initialize movie, error: \(error)")
            }
        }
    }
    
    @objc func hideBeautyBar(){
        UIView.animate(withDuration: 0.3) {
            self.beautyBarBottomContraint.constant = self.beautyBarView.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func flipBtnClicked(_ sender: Any) {
        
    }

    @IBAction func reRecordBtnClicked(_ sender: Any) {
        self.progressTimer.invalidate()
        self.progress = 0
        self.updateButtonAppear()
        removeTmpFile(fileUrl: self.fileUrl!)
        self.recordBtnClicked(sender)
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        DispatchQueue.main.async {
            guard let videoPath = self.fileUrl else { return }

            let keyframePicker = KeyframePickerViewController.create()
            keyframePicker.videoPath = videoPath.absoluteString
            keyframePicker.generatedKeyframeImageHandler = { [weak self] image in
                if image != nil {
                    keyframePicker.dismiss(animated: false, completion: {
                        self?.goVideoPreviewVC(image: image?.image)
                    })
                } else {
                    print("generate image failed")
                }
            }
            self.present(keyframePicker, animated: true, completion: nil)
        }
    }
    
    func goVideoPreviewVC(image: UIImage?) {
        if image != nil {
            let storyboard = UIStoryboard(name: "Moment", bundle: nil)
            let videoPreviewVC = storyboard.instantiateViewController(withIdentifier: "VideoPreviewVC") as! VideoPreviewVC
            videoPreviewVC.previewImage = image
            videoPreviewVC.videoUrl = self.fileUrl
            self.present(videoPreviewVC, animated: true, completion: nil)
        }
    }
 
    @IBAction func stopBtnClicked(_ sender: Any) {
        self.progressTimer.invalidate()
        self.progress = 0
        movieOutput?.finishRecording{
            self.isRecording = false
            self.isFinished = true
            self.videoCamera?.audioEncodingTarget = nil
            self.movieOutput = nil
            DispatchQueue.main.async {
               self.updateButtonAppear()
            }
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateButtonAppear(){
        if(isRecording){
            self.stopBtn.isHidden = false;
            self.recordBtn.isHidden = true
        }else{
            self.stopBtn.isHidden = true;
            self.recordBtn.isHidden = false;
        }
        if(isFinished){
            self.okBtn.isHidden = false;
            self.reRecordBtn.isHidden = false;
            self.recordBtn.isHidden = true;
        }else{
            self.okBtn.isHidden = true;
            self.reRecordBtn.isHidden = true;
        }
    }
    
    func removeTmpFile(fileUrl: URL){
        do {
            try FileManager.default.removeItem(at: fileUrl)
        }catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
}

extension FilterCameraVC: BeautyBarDelegate{
    func beautyCellDidClicked(filterOperation: FilterOperationInterface) {
        self.currentFilter?.filter.removeAllTargets()
        self.videoCamera?.removeAllTargets()
        self.currentFilter = filterOperation
        
        if self.currentFilter?.listName == "aile" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.68))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "cute" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.84))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "april" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.73))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "caomulv" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.12))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "chaotuo" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.4))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "chunzhen" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.3))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "fenchun" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.1))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "hongchun" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.42))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "jiaopi" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.2))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "mianhuatang" {
            self.currentFilter?.updateBasedOnSliderValue(Float(2.0))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "musi" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.82))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "qimiao" {
            self.currentFilter?.updateBasedOnSliderValue(Float(1.45))
            
            let filter = self.currentFilter?.filter as! RGBAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "qingxin" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.3))
            
            let filter = self.currentFilter?.filter as! BrightnessAdjustment
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "shengdai" {
            self.currentFilter?.updateBasedOnSliderValue(Float(0.3))
            
            let filter = self.currentFilter?.filter as! HighlightsAndShadows
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        } else if self.currentFilter?.listName == "taohua" {
            let filter = self.currentFilter?.filter as! ColorBlend
            videoCamera?.addTarget(filter)
            blendImage = PictureInput(imageName:blendImageName)
            blendImage?.addTarget(filter)
            blendImage?.processImage()
            filter.addTarget(renderView)
            videoCamera?.startCapture()
        }else if self.currentFilter?.listName == "wennuan" {
            let filter = self.currentFilter?.filter as! MissEtikateFilter
            
            videoCamera! --> filter --> renderView
            videoCamera?.startCapture()
        }
    }
}
























