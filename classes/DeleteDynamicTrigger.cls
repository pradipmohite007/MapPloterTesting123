Global class DeleteDynamicTrigger 
{
    // used receive response by sending a http request
    private String getResponse(HttpRequest req)
    {
        try
        {
            Http httpreq = new Http();
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            return reqresponse;
        }
        catch (Exception e)
        {
            return 'Error:' +e.getMessage();
        }
    }
    
    // create a http request with required endpoint and request method
    private HttpRequest createHttpRequest(String endpoint, String method)
    {
        HttpRequest req = new HttpRequest();
        endpoint += '';
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod(method);
        return req;
    }
    // used To delete dyanamic trigger 
    public void deleteTrigger(Id triggerId)
    {
        try
        {
            String endpoint = URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v45.0/sobjects';
            HttpRequest req = createHttpRequest(endpoint+'/ApexTrigger/'+triggerId,'DELETE');
            String responseJson = getResponse(req);
        }
        Catch(Exception e)
        {
           system.debug('MPV2 exception occurred==>' + e.getMessage());
        }
    }
}