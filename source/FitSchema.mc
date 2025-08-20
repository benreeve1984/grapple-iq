using Toybox.FitContributor;
using Toybox.Lang;

// Helper module for creating FIT contributor fields
class FitSchema {
    
    function initialize() {}
    
    // Create a FIT contributor field with error handling
    function createField(
        displayName as String,
        fieldId as Number,
        dataType as FitContributor.DataType,
        options as Dictionary
    ) as FitContributor.Field? {
        
        try {
            var field = FitContributor.createField(
                displayName,
                fieldId,
                dataType,
                options
            );
            return field;
        } catch (e) {
            // Field creation failed (e.g., FitContributor not supported)
            System.println("Failed to create FIT field: " + displayName);
            return null;
        }
    }
    
    // Safe method to set field data
    function setFieldData(field as FitContributor.Field?, data as Object) as Void {
        if (field != null) {
            try {
                field.setData(data);
            } catch (e) {
                // Silently handle errors (e.g., invalid data type)
            }
        }
    }
}