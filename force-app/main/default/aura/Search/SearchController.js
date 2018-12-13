({
	onSubmit : function(component, event, helper) {
        var updateSelected = event.getParam("SearchEvent");
        console.log('Search Text'+ updateSelected.searchText);     	
        // The child component is the boat search result
        var childComponent = component.find('childComponent');
        // Call the public method search, on the child component
        childComponent.search(updateSelected.searchText);
    }
})