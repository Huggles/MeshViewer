({
    /**
     * Search event triggered. Retrieve list of matching dossiers from apex
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
	onSubmit : function(component, event, helper) {
        var params = event.getParam("params");
        var responseStub = '[{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"67511325","establishment_city":"UTRECHT","establishment_number":"000036043249","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"legal_name","name":"APPSolutely B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"71836489","establishment_city":"UTRECHT","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"legal_name","name":"APPSolutely Personeelsvereniging"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"05083803","establishment_city":"UTRECHT","establishment_number":"000039101509","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Pento Audiologisch Centrum Utrecht"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"24403408","establishment_city":"UTRECHT","establishment_number":"000039662667","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"Mentaal Beter Utrecht"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30201420","establishment_city":"UTRECHT","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Stichting Islamitisch Centrum Utrecht-Leidsche Rijn"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"52208222","establishment_city":"UTRECHT","establishment_street":"Koekoekstraat","indication_economically_active":false,"match_type":"undetermined","name":"Vereniging van Eigenaars Koekoekstraat 22 en 22A in Utrecht"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"52968073","establishment_city":"UTRECHT","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Vereniging van Eigenaars Kievitdwarsstraat 14 en 14 a te Utrecht"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30184875","establishment_city":"UTRECHT","establishment_number":"000001382969","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Sep Beheer"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30235633","establishment_city":"UTRECHT","establishment_number":"000006758649","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"Garuda projectontwikkeling en consultancy"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"08033388","establishment_city":"UTRECHT","establishment_number":"000007015895","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"Bartels Ingenieursbureau"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30215394","establishment_city":"UTRECHT","establishment_number":"000007373910","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Van Vliet Beheer B.V."},{"correspondence_city":"DE MEERN","correspondence_street":"Postbus","dossier_number":"30166170","establishment_city":"UTRECHT","establishment_number":"000007497504","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Waagemakers & Dufresne B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30169335","establishment_city":"UTRECHT","establishment_number":"000008852014","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Angarde Groep B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30228267","establishment_city":"UTRECHT","establishment_number":"000008894493","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"Helweg ICT Consultancy"},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30254552","establishment_city":"UTRECHT","establishment_number":"000010089004","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"Learn2B B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30228988","establishment_city":"UTRECHT","establishment_number":"000010412530","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"S.P. Habes Beheer B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30215393","establishment_city":"UTRECHT","establishment_number":"000013203665","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"N. van de Geer Beheer B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"30245550","establishment_city":"UTRECHT","establishment_number":"000016527224","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"i-share Consultancy Services B.V."},{"correspondence_city":"DE MEERN","correspondence_street":"Postbus","dossier_number":"30138847","establishment_city":"UTRECHT","establishment_number":"000016539133","establishment_street":"Burgemeester Verderlaan","indication_economically_active":false,"match_type":"undetermined","name":"Auxilia Venture Capital Management B.V."},{"correspondence_city":"UTRECHT","correspondence_street":"Burgemeester Verderlaan","dossier_number":"32073249","establishment_city":"UTRECHT","establishment_number":"000016721578","establishment_street":"Burgemeester Verderlaan","indication_economically_active":true,"match_type":"undetermined","name":"E-Storage Services B.V."}]';

        helper.callServer(component, 'c.search', {searchParams: JSON.stringify(params)}, function(response) {
            helper.handleSearchResults(component, response);
        });//, JSON.parse(responseStub));
    },
    /**
     * Select dossier event triggered. Get dossier from API and save to sObject.
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onSelect : function(component, event, helper) {
        var params = event.getParams();
        component.set('v.selected', params.DossierNumber);
        helper.callServer(component, 'c.getInfo', {dossierNumber: params.DossierNumber, accountId: component.get('v.recordId')}, function(response) {
            helper.handleCompanyData(component);
        });//, true);
    },
    /**
     * Decrement step to allow another search to take place
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    onBack : function (component, event, helper) {
        component.set('v.step', '1');
    }
})