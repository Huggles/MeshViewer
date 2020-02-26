/**
 * Created by jaapbranderhorst on 26/02/2020.
 */

import CreditSafe_Validation_Message_Heading from '@salesforce/label/c.CreditSafe_Validation_Message_Heading';

/**
 * Creates the error message markup for when the validation of the search criteria does turn up problems.
 * @param hints the labels to be shown per search criteria
 */
const createErrorMessageMarkup = function(hints) {
    let errorMessageMarkup;
    errorMessageMarkup = '<div>' + CreditSafe_Validation_Message_Heading + '</div>';
    if (hints) {
        errorMessageMarkup += '<ul>';
        for (const hint of hints) {
            errorMessageMarkup += '<li>';
            errorMessageMarkup += hint;
            errorMessageMarkup += '</li>';
        }
        errorMessageMarkup += '</ul>';
    }
    return errorMessageMarkup;
}

export {createErrorMessageMarkup};