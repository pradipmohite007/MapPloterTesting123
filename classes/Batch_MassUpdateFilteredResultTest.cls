/*
 * Test Class for 1.Batch_MassUpdateFilteredResult(100%)
 * 				  2.MassUpdateHandler(93%)
 * 
 * */
@isTest(seeAllData=false)
public class Batch_MassUpdateFilteredResultTest {
    static testMethod void massUpdateTest() 
    {
        list<Account> lstAcc = new list<Account>();
        list<Id> lstAccIds = new list<Id>();
        
        for(integer i=0;i<10;i++)
        {
        	Account acc = new Account(Name='Test'+i,Industry='Energy');
            lstAcc.add(acc);
        }
        INSERT lstAcc;
        
        for(Account acc: lstAcc)
        {
            lstAccIds.add(acc.Id);
        }
        
        Test.startTest();		
        Batch_MassUpdateFilteredResult obj = new Batch_MassUpdateFilteredResult(lstAccIds,'Industry','Banking','String');
        DataBase.executeBatch(obj,10); 
        Test.stopTest();
        
        List<Account> lstAccRecs = [select Id,Industry from Account where Id =: lstAccIds[0]];
        system.assertEquals(lstAccRecs[0].Industry,'Banking');
    }
}