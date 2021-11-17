/********** 
   Class        : Helper_GoogleAPI
   Author       : Shilpa Kamble 
   Modified by  : Dinesh Deshpande 
   Date         : 09/12/2015 
   Modified Date: 08/23/2018
   History      : v1.6 
   Details      : API call to Google API For Address Geocoding
                  -- This class will additionally provide the feature of using Map Box API 
***********/

global with sharing class Helper_GoogleAPI 
{ 

 
    global MapPointInfo MapAddress(String address)
    {
        try {
            MapPointInfo mapPointInfoObj = new MapPointInfo();

            // HTTP callout
            HttpRequest request = new HttpRequest();
            
            Http http = new Http();
            request.setMethod('GET');
            address = address.replaceAll(Helper_MPConstants.API_SPECIAL_CHARACTERS,' ');
            address = address.replace(' ','+');
            address = address.replace('+++','+');
            
            String url_address;
            String url;    
          
            MapPlotterPremiumSettings__c apiKey = MapPlotterPremiumSettings__c.getValues('GoogleAPIKey');
            MapPlotterPremiumSettings__c googleMapUrl = MapPlotterPremiumSettings__c.getValues('GoogleMapUrl');
            String urlGoogleMapAPI=googleMapUrl.value__c;
            
            if(apiKey.Value__c != null && address != null)   
            {
                    url = urlGoogleMapAPI+'?address='+address+'&sensor=false&key='+apiKey.Value__c; 
                    url = url.replace('++','+');
                    request.setendpoint(url); 
                    
                    JSONGoogleGeoResponse deserialzedResponse;
                    if(test.isRunningTest())
                    {   
                        if(apiKey.Value__c == 'abc') 
                        {
                            deserialzedResponse = JSONGoogleGeoResponse.parse(Test_MPMockHttpResponse.getGeoCodeJSONBodyWithWrongKey());
                        } 
                        else 
                        {
                            deserialzedResponse = JSONGoogleGeoResponse.parse(Test_MPMockHttpResponse.getGeoCodeJSONBody());        
                        }                 
                    }
                    else
                    {
                        try
                        {
                            HTTPResponse resopnse = http.send(request);
                            // Parse Json response.
                            deserialzedResponse = JSONGoogleGeoResponse.parse(resopnse.getbody());
                        }
                        catch(Exception e)
                        {
                            return null;
                        }
                    }   
                    
                    mapPointInfoObj.Status = deserialzedResponse.status;
                    
                    if((deserialzedResponse.status).equalsIgnoreCase('OK') || (deserialzedResponse.status).equalsIgnoreCase('REQUEST_DENIED') || (deserialzedResponse.status).equalsIgnoreCase('ZERO_RESULTS') || (deserialzedResponse.status).equalsIgnoreCase('OVER_QUERY_LIMIT') || (deserialzedResponse.status).equalsIgnoreCase('UNKNOWN_ERROR'))
                    {   
                        if((deserialzedResponse.status).equalsIgnoreCase('OK'))
                        {
                            mapPointInfoObj.Latitude = deserialzedResponse.results[0].geometry.location.lat;
                            mapPointInfoObj.Longitude = deserialzedResponse.results[0].geometry.location.lng;
                            mapPointInfoObj.Geocode_Precision = deserialzedResponse.results[0].geometry.location_type;
                            mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_SUCCESS;
                        } 
                        else if ((deserialzedResponse.status).equalsIgnoreCase('OVER_QUERY_LIMIT'))
                        {
                            mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_PENDING;
                        }
                        else if((deserialzedResponse.status).equalsIgnoreCase('REQUEST_DENIED'))
                        {
                            mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_PENDING;
                        }
                        else if( (deserialzedResponse.status).equalsIgnoreCase('ZERO_RESULTS'))
                        {
                            mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_FAILED; 
                        }
                        else if((deserialzedResponse.status).equalsIgnoreCase('UNKNOWN_ERROR'))
                        {
                            mapPointInfoObj.Status = Helper_MPConstants.GEOCODE_PENDING; 
                        }
                        return mapPointInfoObj;
                    }
                    else
                    {
                        return mapPointInfoObj;                       
                    }  
            }
            return mapPointInfoObj; 
  
        }
        catch(Exception e) {
            return null;
        }              
    }
}