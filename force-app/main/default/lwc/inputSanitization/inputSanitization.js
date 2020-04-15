/**
 * Created by tejaswinidandi on 09/04/2020.
 */

function isNumber(n) {
    return !isNaN(n);
}

const sanitizeStreet = (street) => {
    // \d matches the character class for digits between 0 and 9.
    // for 'Street abc 123' > Array ["Street abc", "123", ""]
    // for '123 Street abc' > Array ["", "123", " Street abc"]
    var a = street.trim().split(/(\d+)/g);

    var houseNumber;
    var houseNumberAddition;
    var streetName;

    //if length is 1, then only street name is available
    if (a.length <= 1)
        return {number: '', street: a.join(''), addition: ''};
    else if (a.length > 1) {
        if (a[0]) { // executes for 'Street 123' > Array ["Street ", "123", ""]
            if (isNumber(a[1])) {
                houseNumber = a[1];
                streetName = a[0].trim();
                if(a.length >= 3)houseNumberAddition = a[2];
            }
        } else { // executes for '123 Street' > Array ["", "123", " Street "]
            if (isNumber(a[1])) {
                houseNumber = a[1];
                streetName = a[2].trim();
                houseNumberAddition = '';
            }
        }
    }

    return {number: houseNumber, street: streetName, addition: houseNumberAddition};
};

export {sanitizeStreet}