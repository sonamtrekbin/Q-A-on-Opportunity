public class TBN_CaptureAnswerController
{
    public String strOpportunityId;
    public TBN_CaptureAnswerController()
    {
        //strOpportunityId= apexPages.currentPage.getParameters.get('Id');
    
    }
    
    public class cNodes
    {
     
     public List<Question__c> parent {get; set;}
     Public Product2 gparent {get;set;}
     public list<Answer__c> lstAnswers = new list<Answer__c>();
     public  Answer__c objAns {get;set;}
     public list<selectOption> lstSelOptions {get;set;}
     public map<string,list<selectOption> > mapSelectOptions {get;set;}
     public string items{get;set;}
     public map<string,string > mapOptions {get;set;}
     public string strTextArea {get;set;}
     public map<string,Answer__c> mapAnswers {get;set;}
     
     public cNodes(string gp, List<Question__c> p)
     {    
         mapSelectOptions  = new map<string,list<selectOption> >();
         mapOptions = new map<string,string >();
         mapAnswers = new map<string,Answer__c>();
         parent = p;
         gparent = [Select Id,Name from product2 where id = :gp limit 1];
                
         
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
                objAns.opportunity__c = '00628000002Yl6G';
                objAns.Product__c = gparent.Id;
                mapAnswers.put(objQues.id,objAns);
                lstAnswers.add(objAns);        
             
            }
            else
            {
                mapAnswers.put(objQues.id,objQues.Answers__r[0]);
            }
            
        }
         
     }
    }
        
    /* end of Wrapper class */ 
    public void insertAnswers()
    {   list<Answer__c> lstToUpdate =  new List<Answer__c>();
        for(cNodes obj :hierarchy)
        {   
            for(Question__c objQues: obj.parent)
            {   
                if(objQues.Answers__r.size() <= 0)
                        lstToUpdate.add(obj.mapAnswers.get(objQues.id)); 
            }
        }
        if(lstToUpdate.size()>0)
        insert lstToUpdate;
        system.debug('=======insert===');
    }
    public void saveAllAnswers()
    {    
        
        list<Answer__c> lstToUpdate =  new List<Answer__c>();
        for(cNodes obj :hierarchy)
        {   
            for(Question__c objQues: obj.parent)
            {
                if(objQues.Type__c == 'picklist')
                    obj.mapAnswers.get(objQues.id).Answer__c = obj.mapOptions.get(objQues.id);
                lstToUpdate.add(obj.mapAnswers.get(objQues.id)); 
            }
        }
        
        upsert lstToUpdate;
    }
    Public List<cNodes> hierarchy;
    
    Public List<cNodes> getmainnodes()
    {
        hierarchy = new List<cNodes>();
        List<product2 > tempparent = [Select Id,Name,Product_Group__c from product2 ];
        
          set<string> setProductGp = new set<string>();
          for(product2 obj:tempparent )
          {
          if(obj.Product_Group__c != null)
          setProductGp .add(obj.Product_Group__c );
          }
         List<Question__c> tempchildren = [Select Id,Product_Group__c,Type__c,Question__c  ,Values__c,Name,(Select Id,Answer__c ,name from Answers__r) from Question__c where Product_Group__c IN :setProductGp ];
         map<string, List<Question__c>> mapToStore = new map<string, List<Question__c>>();
         
         
         List<Question__c> tempchildrenTwo = new list<Question__c>();
         
         for( Question__c onjQues :tempchildren )
         {
             
            tempchildrenTwo = new list<Question__c>();                           
            if(mapToStore.containsKey(onjQues.Product_Group__c  ))
            {   
                tempchildrenTwo = mapToStore.get(onjQues.Product_Group__c  ); 
            }
           
           
            tempchildrenTwo.add(onjQues);
            mapToStore.put(onjQues.Product_Group__c  , tempchildrenTwo);
            
         }
         
         for(product2 objprod : tempparent )
         {
             if(objprod .Product_Group__c != null)
             hierarchy.add(new cNodes(objprod .id,mapToStore.get(objprod.Product_Group__c   ) ));
         }
         
        return hierarchy;
    }   
}