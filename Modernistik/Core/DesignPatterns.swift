//
//  Modernistik
//  Copyright © Modernistik LLC. All rights reserved.
//

import UIKit

/// Protocol that requires the implementor to have a `reuseIdentifier` field.
/// This is normally implemented by items that will go through a recycling phase.
public protocol ReusableType {
    static var reuseIdentifier:String { get }
}

extension ReusableType {
    
    /// Return the reuseIdentifier for this object. By default it is their class name.
    public static var reuseIdentifier:String {
        return String(describing: Self.self)
    }
}

/// An object tha@objc @objc t has a rawValue type that returns an Int.
public protocol IntRepresentable {
    var rawValue: Int { get }
}
/// An object that has a rawValue type that returns a String.
public protocol StringRepresentable {
    var rawValue: String { get }
}

/// Basic protocol for following a standard lifecycle of calls for UIView subclasses.
public protocol ModernViewConformance : class {
    /// This method, called once in the view's lifecycle, should implement
    /// setting up the view's children in the parent's view. This method will be called
    /// when the view is instantiated programmatically or through a storyboard.
    ///
    /// The default implementation does nothing.
    func setupView()
    
    /// This method, should implement changes in the view's interface.
    ///
    /// The default implementation does nothing.
    func updateInterface()
    
    /// This method, should implement resetting any view properties or subviews
    /// when it is going through view recycling, for example, cells in a table view.
    func prepareForReuse()
}

public protocol ModernControllerConformance: class {
    
    /**
     This method will be called once as part of the view controller
     lifecycle, in order for the controller to setup its autolayout
     constraints and add them to the view controller's view property.
     
     The default implmentation of this method does nothing.
     
     - note: If you do not want to inherit the parent's layout constraints in your subclass, you should not
     call super.
     */
    func setupConstraints()
    
    /// This method, should implement changes in the controller's view.
    ///
    /// The default implmentation of this method does nothing.
    func updateInterface()
}

// Default implementations
extension ModernControllerConformance where Self : UIViewController {
    public func setupConstraints() {}
    public func updateInterface() {}
}

public protocol StaticViewMetrics {
    /// The recommended height for this view. The default implementation is the width of
    /// the UIScreen.mainScreen() divided by the aspectRatio.
    static var recommendedHeight: CGFloat { get }
    
    /// Returns the height based on the aspectRatio for a given width. By default, this is
    /// is calculated by width/aspectRatio
    ///
    /// The default implementation returns the `recommendedHeight` value.
    ///
    /// - Parameter forWidth: the width to use when calculating the height.
    /// - Returns: The recommended height based on input width.
    static func recommendedHeight(forWidth:CGFloat) -> CGFloat
}

// Default implementation.
extension StaticViewMetrics {

    public static func recommendedHeight(forWidth:CGFloat) -> CGFloat {
        return recommendedHeight
    }
}

/// Provides a standard interface to get recommended proportional heights based on
/// different sized devices or viewports.
public protocol ProportionalViewMetrics : StaticViewMetrics {
    /// The ratio between width and height of the view. To calculate the height
    /// we would divide the width by the aspectRatio (width/height).
    static var aspectRatio: CGFloat { get }
    /// Returns 1/aspectRatio (height/width).
    static var inverseAspectRatio: CGFloat { get }
}

extension ProportionalViewMetrics {
    /// The ratio between width and height of the view. To calculate the height
    /// we would divide the width by the aspectRatio (width/height).
    public static var aspectRatio:CGFloat { return 1 }
    /// Returns 1/aspectRatio (height/width).
    public static var inverseAspectRatio:CGFloat { return 1 / aspectRatio }
    /// The ratio between width and height of the view. To calculate the height
    /// we would divide the width by the aspectRatio (width/height).
    public static var recommendedHeight:CGFloat {
        return UIScreen.main.bounds.width / aspectRatio
    }
    /// The recommended height for the given with, with respect to the current
    /// aspectRatio (width/height).
    public static func recommendedHeight(forWidth:CGFloat) -> CGFloat {
        return forWidth / aspectRatio
    }
}

extension ReusableType where Self: UITableViewCell {
    
    public static func register(withTableView tableView:UITableView, withIdentifier reuseIdentifier:String = String(describing: Self.self)) {
        tableView.register(Self.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeueReusableCell(inTableView tableView: UITableView, withIdentifier reuseIdentifier:String = String(describing: Self.self)) -> Self {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? Self {
            return cell
        }
        assertionFailure("TableView misconfigured! Failed dequeueing of \(reuseIdentifier)")
        return Self()
    }
    
    public static func dequeueReusableCell(inTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self {
        let ident = String(describing: Self.self)
        if let cell = tableView.dequeueReusableCell(withIdentifier: ident, for: indexPath) as? Self {
            return cell
        }
        assertionFailure("TableView misconfigured! Failed dequeueing of \(ident)")
        return Self()
    }
}

extension ReusableType where Self : UITableViewHeaderFooterView {
    
    public static func register(withTableView tableView:UITableView, withIdentifier reuseIdentifier:String = String(describing: Self.self)) {
        tableView.register(Self.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeueReusableHeaderFooterView(inTableView tableView: UITableView, withIdentifier reuseIdentifier:String = String(describing: Self.self)) -> Self {
        
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? Self {
            return cell
        }
        assertionFailure("TableHeaderFooterView misconfigured! Failed dequeueing of \(reuseIdentifier)")
        return Self()
    }
    
    public static func dequeueReusableHeaderFooterView(inTableView tableView: UITableView) -> Self {
        let ident = String(describing: Self.self)
        
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ident) as? Self {
            return cell
        }
        assertionFailure("TableHeaderFooterView misconfigured! Failed dequeueing of \(ident)")
        return Self()
    }
    
}

extension ReusableType where Self: UICollectionViewCell {
    
    public static func register(withCollectionView collectionView:UICollectionView, withIdentifier reuseIdentifier:String = String(describing: Self.self)) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeueReusableCell(inCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, reuseIdentifier:String = String(describing: Self.self)) -> Self {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Self {
            return cell
        }
        assertionFailure("CollectionView misconfigured! Failed dequeueing of \(reuseIdentifier)")
        return Self()
    }
}

extension ReusableType where Self: UICollectionReusableView {
    
    public static func register(withCollectionView collectionView:UICollectionView, forSupplementaryViewOfKind kind:String, withIdentifier reuseIdentifier:String = String(describing: Self.self)) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeueReusableSupplementaryView(ofKind elementKind:String, inCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, reuseIdentifier:String = String(describing: Self.self)) -> Self {
        
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? Self {
            return view
        }
        assertionFailure("UICollectionReusableView misconfigured! Failed dequeueing of \(reuseIdentifier)")
        return Self()
    }
}

/// Provides an interface for views who need to be loaded from nib/xib files.
public protocol Nibbed {
    static var nib:UINib { get }
}

extension Nibbed where Self: ReusableType, Self: UIView {
    
    /// Load a UINib object for the current view based on the view name.
    public static var nib:UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
    
    /// Load the proper view subclass from its corresponding nib/xib in the main bundle.
    public static func nibView(owner:AnyObject) -> Self {
        let ident = String(describing: Self.self)
        if let view = Bundle.main.loadNibNamed(ident, owner: owner, options: nil)?.first as? Self {
            return view
        }
        assertionFailure("Invalid Nib loading configuration for \(ident)")
        return Self()
    }
}

extension Nibbed where Self: UITableViewCell, Self: ReusableType {
    /// Registers the table cell class using the registered nib file.
    public static func registerNib(withTableView tableView:UITableView) {
        tableView.register(Self.nib, forCellReuseIdentifier: String(describing: Self.self))
    }
}

extension Nibbed where Self: UICollectionViewCell, Self: ReusableType {
    /// Registers the collection cell class using the registered nib file.
    public static func registerNib(withCollectionView collectionView:UICollectionView) {
        collectionView.register(Self.nib, forCellWithReuseIdentifier: String(describing: Self.self))
    }
}


open class ModernHeaderFooterView : UITableViewHeaderFooterView, ReusableType, ModernViewConformance {
 
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    open func setupView() {}
    
    open func updateInterface() {}

}

/// Base view class that follows the general setup/update/reuse pattern when
/// either instantiating from nibs/storyboards or code.
open class ModernView: UIView, ModernViewConformance {
    
    @objc public convenience init(square:CGFloat) {
        self.init(frame: .square(square))
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public required init(autolayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autolayout
        setupView()
    }
    
    @objc open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /// Method where the view should be setup once.
    @objc open func setupView() {
        backgroundColor = .clear
    }
    
    /// This method should be called whenever there is a need to update the interface.
    @objc open func updateInterface() {
        setNeedsDisplay()
    }
    
    /// This method should be called whenever there is a need to reset the interface.
    @objc open func prepareForReuse() {}
    
}


/// Provides a base UITableViewCell class that conforms to the general design lifecycle patterns
/// of setup/update/reuse, etc.
open class ModernTableCell : UITableViewCell, ReusableType, ModernViewConformance {
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    open func setupView() {
        
    }
    
    open func updateInterface() {
        
    }
    
}

/// Provides a base UICollectionViewCell class that conforms to the general design lifecycle patterns
/// of setup/update/reuse, etc.
open class ModernCollectionCell : UICollectionViewCell, ReusableType, ModernViewConformance {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    open func setupView() {}
    
    open func updateInterface() {}
    
    
}

open class ModernButton: UIButton, ModernViewConformance {
    public var minimumHitArea = CGSize.zero
    
    public convenience init(square:CGFloat) {
        self.init(frame: .square(square))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(autolayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autolayout
        setupView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /// Method where the view should be setup once.
    open func setupView() {
        backgroundColor = .clear
    }
    
    /// This method should be called whenever there is a need to update the interface.
    open func updateInterface() {}
    
    /// This method should be called whenever there is a need to reset the interface.
    open func prepareForReuse() {}
    
    @objc open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if minimumHitArea == CGSize.zero { return super.hitTest(point, with: event) }
        // need optimization
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 {
            return nil
        }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
    
}

open class ModernUIControl: UIControl, ModernViewConformance {
    public var minimumHitArea = CGSize.zero
    
    public convenience init(square:CGFloat) {
        self.init(frame: .square(square))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(autolayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autolayout
        setupView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /// Method where the view should be setup once.
    open func setupView() {
        backgroundColor = .clear
    }
    
    /// This method should be called whenever there is a need to update the interface.
    open func updateInterface() {}
    
    /// This method should be called whenever there is a need to reset the interface.
    open func prepareForReuse() {}
    
    @objc open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if minimumHitArea == CGSize.zero { return super.hitTest(point, with: event) }
        // need optimization
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 {
            return nil
        }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
}

open class TappableModernView : ModernView {
    public var minimumHitArea = CGSize.zero
    public var tapActionBlock:(() -> Void)?
    
    override open func setupView() {
        super.setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    @objc open func tapped() {
        tapActionBlock?()
    }
    
    open func tapAction(block: @escaping (() -> Void)) {
        tapActionBlock = block
    }
    
    @objc open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if minimumHitArea == CGSize.zero { return super.hitTest(point, with: event) }
        // need optimization
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 {
            return nil
        }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
}



