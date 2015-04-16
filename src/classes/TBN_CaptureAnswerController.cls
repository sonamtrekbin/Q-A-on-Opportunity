public class TBN_CaptureAnswerController
{
   public string items{get;set;}
    public TBN_CaptureAnswerController()
    {
        
    
    }
    
    public class cNodes
    {
     
     public List<Question__c> parent {get; set;}
     Public Product2 gparent {get;set;}
     public list<Answer__c> lstAnswers = new list<Answer__c>();
     public  Answer__c objAns {get;set;}
     public list<selectOption> lstSelOptions {get;set;}
     //public map<>
     public cNodes(string gp, List<Question__c> p)
     {    
         lstSelOptions = new list<selectOption>();
         parent = p;
         gparent = [Select Id,Name from product2 where id = :gp limit 1];
         
         
         
         for(Question__c objQues : p)
         {    
         
             list<string> lstValues = new list<string>();
             if(objQues.values__c != null)
             {
                 lstValues = objQues.values__c.split(',');
                 for(string str : lstValues )
                 {
                     lstSelOptions.add(new SelectOption(str ,str ));
                 } 
             }
             //lstSelOptions.add(new SelectOption('CANADA','Canada'));
             //lstSelOptions.add(new SelectOption('MEXICO','Mexico'));
             
             if(objQues.Answers__r.size() <= 0)
             {
                 objAns = new Answer__c();
                 objAns.Question__c = objQues.id; 
                 
                 
                 
                 
                // insert objAns;
             }
         }
     }
    }
    /* end of Wrapper class */ 
    
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
         List<Question__c> tempchildren = [Select Id,Product_Group__c,Type__c  ,Values__c,Name,(Select Id,Answer__c ,name from Answers__r) from Question__c where Product_Group__c IN :setProductGp ];
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