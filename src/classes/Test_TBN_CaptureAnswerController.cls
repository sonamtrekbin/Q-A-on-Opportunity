/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_TBN_CaptureAnswerController {

    static testMethod void myUnitTest() {
        Opportunity opp = new Opportunity(Name='Test', CloseDate=Date.today(), StageName='Prospecting');
        insert opp;
        
        list<Product_Group__c> lstProductGroup = new list<Product_Group__c>();
        lstProductGroup.add(new Product_Group__c(Name='TestPG1'));
        lstProductGroup.add(new Product_Group__c(Name='TestPG12'));
        insert lstProductGroup;
        
        list<Product2> lstProduct = new list<Product2>();
        lstProduct.add(new Product2(Name='TestProduct1', Product_Group__c=lstProductGroup[0].id));
        lstProduct.add(new Product2(Name='TestProduct2', Product_Group__c=lstProductGroup[1].id));
        insert lstProduct; 
        
        list<Question__c> lstQuestion = new list<Question__c>();
        lstQuestion.add(new Question__c(Product_Group__c=lstProductGroup[0].id, Question__c='TestQuestion1',Type__c='Textarea'));
        lstQuestion.add(new Question__c(Product_Group__c=lstProductGroup[1].id, Question__c='TestQuestion2',Type__c='Picklist', Values__c='value1,value2'));
        insert lstQuestion; 
        
        TBN_CaptureAnswerController controller = new TBN_CaptureAnswerController();
        controller.strOpportunityId = opp.id;
        controller.getProductandQuestions();
        controller.insertAnswers();
        controller.saveAllAnswers();   
    }
}