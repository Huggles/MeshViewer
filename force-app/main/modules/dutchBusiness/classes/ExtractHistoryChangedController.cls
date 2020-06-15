/**
 * Created by Hugo on 12/06/2020.
 */

public with sharing class ExtractHistoryChangedController {


    @AuraEnabled(Cacheable = false)
    public static String getExtractHistoryChanged(string dossier_number, string start_period, string end_period){
        Date startPeriod;
        Date endPeriod;
        if(start_period != null){
            startPeriod = Date.valueOf(start_period);
        }
        if(end_period != null){
            endPeriod = Date.valueOf(end_period);
        }

        DutchBusinessWsdl.DutchBusinessExtractHistory result = DutchBusinessService.getExtractHistory(dossier_number, startPeriod, endPeriod);
        return JSON.serialize(result);
    }

}