# AlertView-and-ActionSheet-for-iOS-6-to-iOS-10-version-with-action-handler-in-Swift
AlertView and ActionSheet for iOS 6 to iOS 10 version with action handler in Swift


Advantages

used only native controllers

Single line code

easy to use



Disadvantage

cannot be used for complicated purposes

unable to use for alert view with textFields



How to integrate in your project? Add Singleton.h & Singleton.m in your project.

For alert view use the following method for showing alert and if you need to get the action of an alert pass actionHandler.

`Singleton.sharedInstance.showAlert(alertTitle: "title1", alertMessage: "message", arrayOfOtherButtonTitles: ["OK"], cancelButtonTitle: "Cancel", presentInViewController: self, actionHandler: {(/**For cancel, buttonIndex will be zero*/ buttonIndex: Int, _ buttonTitle)  in
            print("pressed\(buttonTitle) with index \(buttonIndex)")
        })`

For action sheet use the following method for showing action sheet and if you need to get the action of an action sheet pass actionHandler.

`Singleton.sharedInstance.showActionSheet(actionSheetTitle: "title1", arrayOfOtherButtonTitles: ["OK"], cancelButtonTitle: "Cancel", presentInViewController: self, actionHandler: {(buttonIndex: Int, _ buttonTitle)  in
            print("pressed\(buttonTitle) with index \(buttonIndex)")
        });`
