/**
 * Created by tejaswinidandi on 25/06/2020.
 */

({
    handleGetReport: function(component, event) {
        var clicked = event.getParam('clicked');
        component.set('v.isClicked', clicked);
    },
});