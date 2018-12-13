({
    
    doSearch: function(component, event, helper) {
        var params = event.getParam('arguments');
       if (params) {
            var searchText = params.searchParam;
            component.set("v.searchText", searchText ); 
            helper.onSearch(component);
            
        }
    },
    onAccountSelect : function( component, event, helper ) {
        Debugger;
        var updateSelected = event.getParam("DossierNumber");
        component.set("v.selectedAccountId", updateSelected.DossierNumber);
    }
    
})