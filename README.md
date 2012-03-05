Building views without IB
==========
1) Change your 'initWithNib' method with just and 'init' method. Set whatever you need in this 'constructor'.
2) Don't use 'loadView'
3) I use 'viewDidLoad' to create my entire view. Here I create all the items that will go in the view and add them as subviews to 'self.view'. You don't need to create the main view object. If you don't do this explicitly, an empty UIView will be created for you. This is what you get from 'self.view' - the empty view. So add your labels, buttons, images, whatever as subviews.
4) Add 'viewWill/DidAppear' methods as needed.