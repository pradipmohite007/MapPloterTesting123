/********** 
   Class   : Helper_Generate_Signature
   Author  : Sandesh Ganjare 
   Date    : 16/05/2016
   History : v1.25 
   Details : Generation of unique signature using the encryption algorithm.
***********/
public with sharing class Helper_Generate_Signature
{
    ///////////////////////////////////
    //Generation of unique signature using the encryption algorithm
    ///////////////////////////////////
    private static List<Organization> lstorgid;
    public static Id getorgid(){
     try{
          //False Positive
         //Access is not check on Organization because irrespective of user permission we need the Organization id.
         if(lstorgid == null){          
            lstorgid = [select Id, IsSandbox, InstanceName, Organizationtype from Organization limit 1];
            return lstorgid[0].Id;             
          } 
         else{
          return lstorgid[0].Id;  
         }
       }
        catch(Exception e){
          system.debug('MPV2 exception occurred==>'+e.getMessage());
          return null;
        }    
    }

    public String getSignature(String string_URL)
    {
        try{
        Id orgId = Helper_Generate_Signature.getorgid();
        MapPlotterPremiumSettings__c googleCryptoKey = MapPlotterPremiumSettings__c.getValues('GoogleCryptoKey');
        String private_key=googleCryptoKey.value__c;

        MapPlotterPremiumSettings__c googleMapUrl = MapPlotterPremiumSettings__c.getValues('GoogleMapUrl');
        String urlGoogleMapAPI=googleMapUrl.value__c;
        String Channel;
        if(orgId != null)
        {
          Channel = String.valueOf(orgId).substring(0, 15);
        URL url = new URL(string_URL);
        String keyString = private_key.replace('-','+');
        String keyStringOne = keyString.replace('_','/');
   
        Blob key= EncodingUtil.base64Decode(keyStringOne);
        String path = url.getPath();
        String query = url.getQuery();
        String resource = path + '?' + query;
        Blob data = crypto.generateMac('hmacSHA1',Blob.valueOf(resource),key);
        String signature = EncodingUtil.base64Encode(data);
        String signatureOne = signature.replace('+', '-');
        String signatureFinal = signatureOne.replace('/', '_');
        String finalURL = urlGoogleMapAPI+'?'+query+'&signature='+signatureFinal+'&channel='+Channel;
        return finalURL;
        }
        else{
         return null;
        }
      }
      catch(Exception e){
        system.debug('MPV2 exception occurred==>'+e.getMessage());
        return null;
      }
    }  
}