public with sharing class TBN_CaptureAnswerController {
	public list<Product2> lstProd = new list<Product2>();
	public list<Question__c> lstQues = new list<Question__c>();
	public list<String> lststr = new list<String>();
	public List<customField> fieldList { get; set; }
	//public list<wrapperQuestionSets> lstWrapperQuestionSets()	{get; set;}
	
	public class wrapperQuestionSets
	{
		String product	{get; set;}
		String Question	{get; set;}
		
		public wrapperQuestionSets(String product, String Question)
		{
			this.product = product;
			this.Question = Question;
		}
	}
	public TBN_CaptureAnswerController()
	{
		fieldList = new List<customField>();
		lstProd=[SELECT id, Name, Product_Group__c from Product2];
		for(Product2 p: lstProd)
		{
			if(p.Product_Group__c!=null)
				lststr.add(p.Product_Group__c);
		}
		system.debug('===='+lststr);
		lstQues=[select id, Question__c from Question__c where Product_Group__c IN: lststr];
		//lstQues = [SELECT Id, Question__c, Product_Group__c FROM Question__c WHERE Product_Group__c IN (SELECT Product_Group__c FROM Product2)];
		system.debug('-----'+lstQues); 
	}
	
	public class customField 
    { 
        public String fieldType { get; set; } 
        private String Value; 
        public String getTextValue() 
        { 
            return value; 
        } 
        public String getCheckValue() 
        { 
            return value; 
        } 
        public String getTextAreaValue() 
        { 
            return value; 
        } 
        public void setTextValue(String s) 
        { 
            value = s; 
        } 
        public void setCheckValue(String s) 
        { 
            value = s; 
        } 
        public void setTextAreaValue(String s) 
        { 
            value = s; 
        } 
        public Boolean getIsText() 
        { 
            return fieldType == 'text'; 
        } 
        public Boolean getIsCheck() 
        { 
            return fieldType == 'check'; 
        } 
        public Boolean getIsTextArea() 
        { 
            return fieldType == 'area'; 
        } 
        public List<SelectOption> getDataTypeList() 
        { 
            List<SelectOption> dataTypes = new List<SelectOption>(); 
            dataTypes.add(new SelectOption('text','Text Field')); 
            dataTypes.add(new SelectOption('check','Checkbox')); 
            dataTypes.add(new SelectOption('area','Text Area')); 
            return dataTypes; 
        } 
    } 

    public void addRow() 
    { 
        customField cf = new customField(); 
        cf.fieldType = 'text';
        cf.setTextValue(''); 
        fieldList.add(cf); 
    } 
}