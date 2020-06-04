/**
 * Created by jaapbranderhorst on 02/06/2020.
 */

/**
 * Replaces parameters {0} etc in given labels with the given value. Example invocation myFormattedLabel = format(this.label.MyToBeFormattedLabel, ['value param 1', 'value param 2']);
 * @param label the label to be formatted
 * @param [args] the values to be replaced
 * @returns {*}
 */
const format = (label, params) => {
    // var args = Array.prototype.slice.call(arguments, 1);
    return label.replace(/{(\d+)}/g, function(match, number) {
        return typeof params[number] != 'undefined'
            ? params[number]
            : match
            ;
    });
};

export {format}