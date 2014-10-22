//
//  MUFormConstants.h
//  MeetupApp
//
//  Created by Wes on 8/15/13.
//
//

///-------------------------------------------------------------------
/// @name Form Metadata Keys
///-------------------------------------------------------------------

/** Returns a dictionary of form metadata accessible with the following `MUFormMetadata<Item>Key` keys. */
extern NSString *const MUFormMetadataKey;

/** Returns the localized key for the form title. */
extern NSString *const MUFormLocalizedMetadataTitleKey;

/** The string table for all FormKit strings. */
extern NSString *const MUFormKitStringTable;


///-------------------------------------------------------------------
/// @name Form Section Info Keys
///-------------------------------------------------------------------

/** Returns an array of sections for the form. */
extern NSString *const MUFormSectionsKey;

/** Indicates whether or not a section is enabled in the form. */
extern NSString *const MUFormSectionEnabledPropertyNameKey;

/** Returns the localized key for a form section header. */
extern NSString *const MUFormLocalizedSectionHeaderTitleKey;

/** Returns the localized key for a form section footer. */
extern NSString *const MUFormLocalizedSectionFooterTitleKey;

/** The name of a property on the model. Show the header if and only if the value of that property is not @NO. */
extern NSString *const MUFormSectionHeaderEnabledPropertyNameKey;

/** The name of a property on the model. Show the footer if and only if the value of that property is not @NO. */
extern NSString *const MUFormSectionFooterEnabledPropertyNameKey;

/** Returns the max cell count for dynamic cell counts within a section */
extern NSString *const MUFormSectionDynamicRowLimitKey;

/** Returns an array of `NSDictionary` row info objects. */
extern NSString *const MUFormSectionRowsKey;

/** Indicates the height of a section header. */
extern NSString *const MUFormSectionHeaderHeightKey;

/** Indicates the height of a section footer. */
extern NSString *const MUFormSectionFooterHeightKey;

///-------------------------------------------------------------------
/// @name  Dynamic Form Datasource
///-------------------------------------------------------------------


/** Indicates a prototype row definition for a dynamic row. */
extern NSString *const MUFormSectionRowPrototypeKey;

/** Indicates a row definition a tappable 'Add new' style row */
extern NSString *const MUFormSectionRowAddKey;

/** A keyPath to access an NSArray property for dynamic row objects */
extern NSString *const MUFormSectionArrayKeypathKey;

/** A keyPath to access an individual property of each array item */
extern NSString *const MUFormSectionIndexedValueKeypathKey;



///-------------------------------------------------------------------
/// @name  Form Row Info Dictionary Keys
///-------------------------------------------------------------------


/** The identifier for the cell representing the row. */
extern NSString *const MUFormCellIdentifierKey;

/** Specifies the class of a cell. */
extern NSString *const MUFormCellClassKey;

/** Specifies an optional tag for a row, useful for accessing explicitly in code. */
extern NSString *const MUFormCellTagKey;

/** Specifies an optional tag for a section, useful for accessing explicitly in code. */
extern NSString *const MUFormSectionTagKey;

/** Specifies the accessibility hint of a cell. */
extern NSString *const MUFormCellLocalizedAccessibilityHintKey;

/** Specifies that this cell is a button, and will be described as a button in accessibility traits. */
extern NSString *const MUFormCellAccessibilityButtonTraitKey;

/** Localized Key for text for a cell's label. */
extern NSString *const MUFormLocalizedStaticTextKey;

/** Indicates the cell accesory type to be used. */
extern NSString *const MUFormCellAccessoryTypeKey;

/** A keyPath to access a property (supersedes `MUFormPropertyNameGetterKey` and `MUFormPropertyNameSetterKey`). */
extern NSString *const MUFormPropertyNameKey;

/** A keyPath to access a boolean dependency when using 'MUFormDependentPropertyNameKey'. currently supported only via textfield */
extern NSString *const MUFormDependencyPropertyNameKey;

/** A keyPath to access a property whose boolean value indicates whether a row item should be displayed. */
extern NSString *const MUFormDependentPropertyNameKey;

/** A keyPath to access a getter property. */
extern NSString *const MUFormPropertyNameGetterKey;

/** A keyPath to access a setter property. */
extern NSString *const MUFormPropertyNameSetterKey;

/** A dictionary of additional attributes useful to a data-source item. */
extern NSString *const MUFormCellAttributeNamesKey;

/** A dictionary of values generated from cell attribute name keys. */
extern NSString *const MUFormCellAttributeValuesKey;

/** The default number value a cell is representing. */
extern NSString *const MUFormDefaultValueKey;

/** The localized key for the default or placeholder string value that a cell is representing. */
extern NSString *const MUFormLocalizedDefaultValueKey;

/** The UITextAutocorrectionType for cells with text fields */
extern NSString *const MUFormUITextAutocorrectionTypeKey;

/** The UIKeyboardType for cells with text fields */
extern NSString *const MUFormUIKeyboardTypeKey;

/** The UIReturnKey for cells with text fields */
extern NSString *const MUFormUIReturnKeyTypeKey;

/** The UITextAutocapitalizationType for cells with text fields */
extern NSString *const MUFormUITextAutocapitalizationTypeKey;

/** An accessibility label to assign to the dominant item in the form cell */
extern NSString *const MUFormLocalizedAccessibilityLabelKey;

/** Returns a localized key for a message to be displayed in a cell's `messageLabel`. */
extern NSString *const MUFormLocalizedCellMessageKey;

/** Returns a segue identifier. */
extern NSString *const MUFormCellSegueIdentifierKey;

/** The name of an icon image file. */
extern NSString *const MUFormCellIconNameKey;

/** The URL of an icon image file. */
extern NSString *const MUFormCellIconURLStringKey;

/** A localized key for a bit of meta data (e.g. A title for modal controllers invoked by tapping a cell). */
extern NSString *const MUFormLocalizedMetaStringKey;

/** Indicates that a row has text input and should become the first responder when displayed. */
extern NSString *const MUFormBecomeFirstResponderKey;

/** An identifier to indicate what action should be taken when a cell is tapped (this is a temporary solution) */
extern NSString *const MUFormTapActionIdentifierKey;

/** The file name of another form data source. */
extern NSString *const MUFormDataSourceFileNameKey;

/** Maximum characters allowable for text field entry (currenty only supported in number text field) */
extern NSString *const MUFormMaximumCharactersKey;

/** Indicates the height of a row. */
extern NSString *const MUFormRowHeightKey;

/** Enable secure entry for text fields. */
extern NSString *const MUFormCellSecureTextEntryEnabledKey;

/** Set to @YES to disable the main control of this cell. */
extern NSString *const MUFormCellIsDisabledKey;

