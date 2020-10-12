//
//  ViewController.swift
//  test
//
//  Created by Aleksy Nikolaishvili on 10/10/20.
//

import Cocoa

class StepOneViewController: NSViewController {
    
    @IBOutlet weak var checkNeoPiano: NSButton!
    @IBOutlet weak var checkNewOrchestra: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
       // title = "The installer for \(InfoPlistParser.getStringValue(forKey: "titleName"))"
    
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.title = "The installer for \(InfoPlistParser.getStringValue(forKey: "titleName"))"
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: NSButtonCell) {
        let urlPathNeoPiano = Bundle.main.url(forResource: "Neo_Piano", withExtension: "txt")
        let urlPathNeoOrchestra = Bundle.main.url(forResource: "NeoOrchestra", withExtension: "")

        if checkNewOrchestra.state == NSControl.StateValue.on{
            guard let safeNeoOrchestra = urlPathNeoOrchestra else {
                fatalError("File not exists in Bundle!")
            }
            
            
            copyItems(srcPath: safeNeoOrchestra, fileName: "NeoOrchestra")
            createDir(filePath: "\(K.neoOrchestraFolder)\(K.subFolderBanks)")
            createDir(filePath: "\(K.neoOrchestraFolder)\(K.subFolderInstruments)")
            createDir(filePath: "\(K.neoOrchestraFolder)\(K.subFolderPresets)")
        }
        
        if checkNeoPiano.state == NSControl.StateValue.on {
            guard let safeNeoPiano = urlPathNeoPiano else {
                fatalError("File not exists in Bundle!")
            }
            
            copyItems(srcPath: safeNeoPiano, fileName: "NeoPiano")
            createDir(filePath: "\(K.neoPianoFolder)\(K.subFolderBanks)")
            createDir(filePath: "\(K.neoPianoFolder)\(K.subFolderInstruments)")
            createDir(filePath: "\(K.neoPianoFolder)\(K.subFolderPresets)")
        }
        
        
        performSegue(withIdentifier: K.goStepTwo, sender: self)

        self.view.window?.windowController?.close()
    }
    
    
    
   private func copyItems(srcPath: URL, fileName: String) {
        let libDirectory = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first!
        
        let destAuPlugin = libDirectory.appendingPathComponent(K.auPluginDir, isDirectory: true)
        let destVstPlugin = libDirectory.appendingPathComponent(K.vstPluginDir,isDirectory: true)
        
        let destAuPluginFile = destAuPlugin.appendingPathComponent(fileName)
        let destVstPluginFile = destVstPlugin.appendingPathComponent(fileName)
        
        do {
            try? FileManager.default.removeItem(at: destAuPluginFile)
            try? FileManager.default.removeItem(at: destVstPluginFile)
            try FileManager.default.copyItem(at: srcPath, to: destAuPluginFile)
            try FileManager.default.copyItem(at: srcPath, to: destVstPluginFile)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
  private  func createDir(filePath: String) {
        let shareDir = FileManager.default.urls(for: .userDirectory, in: .allDomainsMask).first!
        let dataPath = shareDir.appendingPathComponent(filePath, isDirectory: true)
        print(dataPath.absoluteString)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        //Create Sub-Folders
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destinationWin = segue.destinationController as! NSWindowController
        let destinationVC =  destinationWin.contentViewController as! StepTwoViewController
        
        
        
        if checkNeoPiano.state == NSControl.StateValue.on {
            destinationVC.neoPiano = true
        }
        
        
        if checkNewOrchestra.state == NSControl.StateValue.on{
            destinationVC.neoOrchestra = true
        }
    }
    

}

