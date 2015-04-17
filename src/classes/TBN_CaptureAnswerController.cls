/**
* \arg ClassName      : TBN_CaptureAnswerController
* \arg CreatedOn      : 15/04/2015
* \arg LastModifiedOn : 17/04/2015
* \arg CreatededBy    : Sonam Rose Joseph
* \arg ModifiedBy     : Sonam Rose Joseph   
*                       
*/
public class TBN_CaptureAnswerController
{
	/* Start Variables */
    public string strOpportunityId;
    Public List<wrapperClass> lstWrapperClass;
    /* End Variables*/
    
    /* Start Constructor*/
    public TBN_CaptureAnswerController()
    {
        strOpportunityId=  ApexPages.currentPage().getParameters().get('Id');
    }
    /* End Contructor */
    
    /* Start wrapper class */
    public class wrapperClass
    {
        public List<Question__c> lstQuestion {get; set;}
        public Product2 objProduct {get;set;}
        public list<Answer__c> lstAnswers = new list<Answer__c>();
        public  Answer__c objAns {get;set;}
        public list<selectOption> lstSelOptions {get;set;}
        public map<string,list<selectOption> > mapSelectOptions {get;set;}
        public map<string,string > mapOptions {get;set;}
        public map<string,Answer__c> mapAnswers {get;set;} 
     	
     	/* Wrapper class constructor */
        public wrapperClass(string strOppId, string gp, List<Question__c> p)
        { 
        	try
        	{   
	             mapSelectOptions  = new map<string,list<selectOption> >();
	             mapOptions = new map<string,string >();
	             mapAnswers = new map<string,Answer__c>();
	             lstQuestion = p;
	             objProduct = [Select Id,Name from product2 where id = :gp limit 1];
	         
	             for(Question__c objQues : p)
	             {    
	                lstSelOptions = new list<selectOption>();
	                list<string> lstValues = new list<string>();
	                if(objQues.values__c != null)
	                {
	                    lstValues = objQues.values__c.split(',');
	                    for(string str : lstValues )
	                    {
	                        lstSelOptions.add(new SelectOption(str ,str ));
	                    } 
	                }
	                mapSelectOptions.put(objQues.id, lstSelOptions );
	                mapOptions.put(objQues.id, '' );
	                if(objQues.Answers__r.size() <= 0)
	                {
	                    objAns = new Answer__c();
	                    objAns.Question__c = objQues.id; 
	                    objAns.opportunity__c = strOppId;
	                    objAns.Product__c = objProduct.Id;
	                    mapAnswers.put(objQues.id,objAns);
	                    lstAnswers.add(objAns);        
	                }
	                else
	                {
	                    mapAnswers.put(objQues.id,objQues.Answers__r[0]);
	                }
	            }
        	}
        	catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,'Internal error occurred. Please contact adminstrator'));
            } 
        }
        /* End of wrapper class constructor */
    }
    /*End of wrapper class*/ 
    
    /*!
        * MethodName : insertAnswers  
        * param      : --
        * Description: This method creates answer records on load of the page. 
    */
    /* Start method*/ 
    public void insertAnswers()
    {
    	try
    	{   
	        list<Answer__c> lstToUpdate =  new List<Answer__c>();
	        for(wrapperClass obj :lstWrapperClass)
	        {   
	            for(Question__c objQues: obj.lstQuestion)
	            {   
	                if(objQues.Answers__r.size() <= 0)
	                    lstToUpdate.add(obj.mapAnswers.get(objQues.id)); 
	            }
	        }
	        if(lstToUpdate.size()>0)
	            insert lstToUpdate;
    	}
    	catch(Exception e)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,'Internal error occurred. Please contact adminstrator'));
        } 
    }
    /* End method */
    
    /*!
        * MethodName : saveAllAnswers  
        * param      : --
        * Description: This method inserts answers into the Answer__c field of the record that was created during the load of page and updates the records. 
    */
    /* Start method*/ 
    public void saveAllAnswers()
    {  
    	try
    	{  
	        list<Answer__c> lstToUpdate =  new List<Answer__c>();
	        for(wrapperClass obj :lstWrapperClass)
	        {   
	            for(Question__c objQues: obj.lstQuestion)
	            {
	                if(objQues.Type__c == 'picklist')
	                    obj.mapAnswers.get(objQues.id).Answer__c = obj.mapOptions.get(objQues.id);
	                
	                lstToUpdate.add(obj.mapAnswers.get(objQues.id)); 
	            }
	        }
	        upsert lstToUpdate;
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,'Answers has been saved successfully'));
    	}
    	catch(Exception e)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,'Internal error occurred. Please contact adminstrator'));
        } 
    }
    /* End method */
    
    /*!
        * MethodName : getProductandQuestions  
        * param      : --
        * Description: This method fetches the questions for products based on their product group. 
    */
    /* Start method*/ 
    Public List<wrapperClass> getProductandQuestions()
    {
    	try
    	{
	        lstWrapperClass = new List<wrapperClass>();
	        List<product2 > tempProduct = [Select Id,Name,Product_Group__c from product2 ];
	        set<string> setProductGp = new set<string>();
	        for(product2 obj:tempProduct)
	        {
	            if(obj.Product_Group__c != null)
	                setProductGp .add(obj.Product_Group__c);
	        }
	        List<Question__c> tempQuestion = [Select Id,Product_Group__c,Type__c,Question__c,Values__c,Name,
	        								(Select Id,Answer__c ,name from Answers__r where Opportunity__c =: strOpportunityId) 
	        								from Question__c where Product_Group__c IN :setProductGp];
	        map<string, List<Question__c>> mapToStore = new map<string, List<Question__c>>();
	        List<Question__c> tempQuestion2 = new list<Question__c>();
	        for( Question__c onjQues :tempQuestion )
	        {
	            tempQuestion2 = new list<Question__c>();                           
	            if(mapToStore.containsKey(onjQues.Product_Group__c))
	            {    
	                tempQuestion2 = mapToStore.get(onjQues.Product_Group__c); 
	            }
	            tempQuestion2.add(onjQues);
	            mapToStore.put(onjQues.Product_Group__c  , tempQuestion2);
	        }
	         
	        for(product2 objprod : tempProduct)
	        {
	            if(objprod .Product_Group__c != null)
	                lstWrapperClass.add(new wrapperClass(strOpportunityId,objprod.id,mapToStore.get(objprod.Product_Group__c)));
	        }
	        return lstWrapperClass;
    	}
    	catch(Exception e)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,'Internal error occurred. Please contact adminstrator'));
        	return null;
        } 
    } 
    /* End method */   
}