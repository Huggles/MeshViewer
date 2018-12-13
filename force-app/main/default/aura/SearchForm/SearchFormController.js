({
    // Handle the event to submit the input search string
    onSearchSubmit: function( component, event, helper ) {
        // Getting the string
        var searchString = component.get("v.searchText");
        // Getting the event
        var updateEvent = component.getEvent("SearchEvent");
        // Setting the param on the event
        updateEvent.setParams({ "SearchEvent": {
            "searchText" : searchString
        }
        });
        // Fire the event
        updateEvent.fire();
    },
    handleChange: function(component,event,helper){
        component.set("v.SelectedAPI", component.find("levels").get("v.value"));
    },
    changeState : function changeState (component){ 
        component.set('v.isexpanded',component.get('v.isexpanded'));
    }
    
})