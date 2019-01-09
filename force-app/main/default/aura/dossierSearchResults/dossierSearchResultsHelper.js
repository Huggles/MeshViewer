({
    // Fetch the accounts from the Apex controller
    onSearch: function(component) {
        var action = component.get('c.search');
        console.log('Initial Searh: ' + component.get('v.searchText'));
        action.setParams({ searchText : component.get('v.searchText')});
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") {
                console.log('Retrun List: ' + actionResult.getReturnValue());
                console.log('Json Stringify '+ (JSON.stringify(actionResult.getReturnValue())));  
                component.set('v.wrapperList', actionResult.getReturnValue());
            } else if (state === "ERROR") {
                var errors = actionResult.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
})