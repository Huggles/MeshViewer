public with sharing class dutchBusinessSearchParametersResponse {

// paging info, might be wrong and have more functionallity around that
    public Integer curpage;
    public Integer perpage;
    public Integer numpages;
    public Integer numresults;
    public Integer maxresults;
    public List<DutchBusinessReference> items;


    public dutchBusinessSearchParametersResponse(){
        items = new List<DutchBusinessReference>();
    }

class DutchBusinessReference{
    public String dossier_number;
    public String establishment_number;
    public String name;
    public String match_type;
    public String establishment_city;
    public String establishment_street;
    public String correspondence_city;
    public String correspondence_street;
    public Boolean indication_economically_active;
}

}
