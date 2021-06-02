/*
* Note: Org must have state/country enabled before using this
*
*/

public class StateCountryDependent {


    @AuraEnabled
    public static List<String> allCountries(){
        String[] countries =new String[]{};
        Schema.DescribeFieldResult fieldResult = Account.BillingCountrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            countries.add(f.getLabel());
        }
        return countries;
    }


    /**
    * Methods allCountries and loadCountriesAndStates both are used to display
    * Dependent pick-list value into the lightning component
    * Method : allCountries is used to pull all the country name from the global pick-list value
    * Method : loadCountriesAndStates is used to make the states with respect to the country name.
    * Method : getSalutation is used to display salutation that is present in contact object
    * */

    @AuraEnabled
    public static Map<String,String[]> loadCountriesAndStates(){
        Map<String,String[]> countryVsStates = new Map<String,String[]>();
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'countryStateJSON' LIMIT 1];
        String body = sr.Body.toString();
        Map<String, Object> dataMap = new Map<String, Object>();
        dataMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        List<Object> countries = new List<Object>();
        if(dataMap.containsKey('countries')){
            countries = (List<Object>)dataMap.get('countries');
            for (Object country : countries) {
                String countryName = '';
                String[] states = new String[]{};

                Map<String, Object> conVsState = (Map<String, Object>)country;
                
                if(conVsState.containsKey('country')){
                    countryName = (String)conVsState.get('country');
                }
                if(conVsState.containsKey('states')){
                    for (Object state : (List<Object>)conVsState.get('states')) {
                        states.add((String)state);
                    }
                }
                if(countryName != ''){
                    countryVsStates.put(countryName,states);
                }
            }
        }  

        System.debug('countryVsStates'+countryVsStates.size());
        return countryVsStates;
        
    }


}