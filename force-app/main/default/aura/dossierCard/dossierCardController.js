({
        /**
         * Inform parent comnponent about required dml action on account.
         * @param {*} component 
         * @param {*} event 
         * @param {*} helper 
         */
        onClick : function(component, event, helper) {
            // Getting the event
            var createEvent = component.getEvent("toUpdateAccountEvent");
            // Fire the event so all the components can hear it
            console.log('toUpdateAccount firing ');
            createEvent.fire();
    }
});