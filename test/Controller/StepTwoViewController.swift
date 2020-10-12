//
//  stepTwoViewController.swift
//  test
//
//  Created by Aleksy Nikolaishvili on 10/11/20.
//

import Cocoa

class StepTwoViewController: NSViewController {
    @IBOutlet weak var textNeoOrchestra: NSTextField!
    
    @IBOutlet weak var textNeoPiano: NSTextField!
    
    @IBOutlet weak var browseNeoOrchestra: NSButton!
     
    @IBOutlet weak var browseNeoPiano: NSButton!
    
    var neoPiano: Bool? {
        didSet{
            print("NeoPiano True")
            if let safeNeoPiano = neoPiano {
                textNeoPiano.isHidden = !safeNeoPiano
                browseNeoPiano.isHidden = !safeNeoPiano
            }
            
        }
    }
    
    var neoOrchestra: Bool? {
        didSet{
          print("NeoOrchestra true")
            if let safeNeoOrchestra = neoOrchestra {
                textNeoOrchestra.isHidden = !safeNeoOrchestra
                browseNeoOrchestra.isHidden = !safeNeoOrchestra
            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.title = "The installer for \(InfoPlistParser.getStringValue(forKey: "titleName"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        textNeoOrchestra.stringValue = K.neoOrchestraDefaultInstrumentFolder
        textNeoPiano.stringValue = K.neoPianoDefaultInstrumentFolder
    }
    
    @IBAction func pressBrowseNeoOrchestra(_ sender: NSButton) {
        if let safeDialogResult = Dialog().openDialog() {
            textNeoOrchestra.stringValue = safeDialogResult.absoluteString
           // urlNeoOrchestra?.appendPathComponent(safeDialogResult, isDirectory: <#T##Bool#>)
        }
        
    }
    
    @IBAction func pressBrowsePianoOrchestra(_ sender: NSButton) {
        if let safeDialogResult = Dialog().openDialog() {
            textNeoPiano.stringValue = safeDialogResult.absoluteString
           // urlNeoPiano = safeDialogResult
        }
    }
    
    @IBAction func pressCopy(_ sender: NSButton) {
        
        copyFilesFromBundleToDirFolderWith(fileExtension: "png", destPath: textNeoOrchestra.stringValue)
        copyFilesFromBundleToDirFolderWith(fileExtension: "png", destPath: textNeoPiano.stringValue)
        copyFilesFromBundleToDirFolderWith(fileExtension: "ins", destPath: textNeoOrchestra.stringValue)
        copyFilesFromBundleToDirFolderWith(fileExtension: "ins", destPath: textNeoPiano.stringValue)
        
        performSegue(withIdentifier: K.goStepThree, sender: self)
        
        self.view.window?.windowController?.close()
    }
    

    
   private func copyFilesFromBundleToDirFolderWith(fileExtension: String, destPath: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                print(dirContents)
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    print(fileName)
                    guard let src = Bundle.main.url(forResource: fileName, withExtension: "") else {
                        fatalError("file not exist in bundle!")
                    }
                    guard let dst = URL(string: "\(destPath)\(fileName)") else {
                        fatalError("destination error")
                    }
                    do {
                        try? FileManager.default.removeItem(at: dst)
                        try FileManager.default.copyItem(at: src, to: dst)
                        
                    } catch { print(error) }
                }
            } catch {print(error) }
        }
    }
    
    
    
}
