//
//  SteThreeViewController.swift
//  test
//
//  Created by Aleksy Nikolaishvili on 10/12/20.
//

import Cocoa

class StepThreeViewController: NSViewController {
    @IBOutlet weak var textBrowse: NSTextField!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.title = "The installer for \(InfoPlistParser.getStringValue(forKey: "titleName"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func pressBrowse(_ sender: NSButton) {
        if let safeDialogResult = Dialog().openDialog() {
            textBrowse.stringValue = safeDialogResult.absoluteString
        }
    }
    @IBAction func copyPressed(_ sender: NSButton) {
        copyFilesFromFolderToLocation(fileExtension: "nsp", destPath: textBrowse.stringValue, sourcePath: "\(K.usersFolder)\(K.neoOrchestraFolder)\(K.subFolderPresets)/")
        copyFilesFromFolderToLocation(fileExtension: "nsp", destPath: textBrowse.stringValue, sourcePath: "\(K.usersFolder)\(K.neoOrchestraFolder)\(K.subFolderBanks)/")
        
        Command().shell("osascript -e 'tell app \"loginwindow\" to «event aevtrrst»'")
    }
    
   private func copyFilesFromFolderToLocation(fileExtension: String, destPath: String, sourcePath: String) {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: sourcePath)
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    print(fileName)
                    guard let src = URL(string: "file://\(sourcePath)\(fileName)") else {
                        return
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
