//
//  Dialog.swift
//  test
//
//  Created by Aleksy Nikolaishvili on 10/12/20.
//

import Foundation
import Cocoa

struct Dialog {
    func openDialog() -> URL? {
        let dialog = NSOpenPanel();
          
          dialog.title                   = "Choose a Folder";
          dialog.showsResizeIndicator    = true;
          dialog.showsHiddenFiles        = false;
          dialog.canChooseFiles          = false
          dialog.canChooseDirectories    = true;
          dialog.canCreateDirectories    = true;
          dialog.allowsMultipleSelection = false;
        
        var path:URL?

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
              
              if (result != nil) {
                 path = result!
               
              }
          }
              //else {
//              // User clicked on "Cancel"
//              return
//          }
    
        return path
    }
}
