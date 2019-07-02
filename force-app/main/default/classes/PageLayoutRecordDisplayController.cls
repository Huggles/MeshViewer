public with sharing class PageLayoutRecordDisplayController {
    @AuraEnabled
    
    public static PageLayout getPageLayoutMetadata(String pageLayoutName, String objectName) {
        List<String> componentNameList = new List<String>{pageLayoutName};
        
        if (String.isBlank(pageLayoutName)) {
            return new PageLayout();
        }
        
        List<Metadata.Metadata> layouts =  
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);

        if (layouts.size() == 1) {
            return new PageLayout((Metadata.Layout) layouts[0], objectName);
        }
        
        return new PageLayout();
    }
    
    public class PageLayout {
        @AuraEnabled
        public List<PageLayoutSection> Sections { get; set; }
        map<String,String> fieldName2fieldFullNameMap;

        public PageLayout() {
            Sections = new List<PageLayoutSection>();
            fieldName2fieldFullNameMap = new map<String,String>();
        }
        
        public PageLayout(Metadata.Layout layout, String objectName) {
            this();
            populateFieldName2FieldFullNameMap(objectName);
            for (Metadata.LayoutSection section : layout.layoutSections) {
                if (section.style != Metadata.LayoutSectionStyle.CustomLinks) {
                    Sections.add(new PageLayoutSection(section, fieldName2fieldFullNameMap));
                }
            }
        }
        // Metadata.LayoutItem.field gives the local api name of the object(no namespace), so the map<localName, fullName> of all object fields is created for further usage
        public void populateFieldName2FieldFullNameMap(String sObjectName){
            map<string, Schema.sObjectField> fieldMap=Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
            for(String fName: fieldMap.keySet()){
                fieldName2fieldFullNameMap.put(fieldMap.get(fName).getDescribe().getLocalName(), fieldMap.get(fName).getDescribe().getName());
            }
        }
    }
    
    public class PageLayoutSection {
        @AuraEnabled
        public List<PageLayoutSectionColumn> Columns { get; set; }
        
        @AuraEnabled
        public String Label { get; set; }
        
        public PageLayoutSection(Metadata.LayoutSection section, map<String,String> fieldName2fieldFullNameMap) {
            Columns = new List<PageLayoutSectionColumn>();
            
            Label = section.label;
            
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                Columns.add(new PageLayoutSectionColumn(column, fieldName2fieldFullNameMap));
            }
        }
    }
    
    public class PageLayoutSectionColumn {
        @AuraEnabled
        public List<PageLayoutField> Fields { get; set; }
        
        public PageLayoutSectionColumn(Metadata.LayoutColumn column, map<String,String> fieldName2fieldFullNameMap) {
            Fields = new List<PageLayoutField>();
            
            if (column.layoutItems == null) {
                return;
            }

            for (Metadata.LayoutItem item : column.layoutItems) {
                
                Fields.add(new PageLayoutField(item, fieldName2fieldFullNameMap));
            }
        }
    }
    
    public class PageLayoutField { //vprok modified
        @AuraEnabled
        public String APIName { get; set; }

        public PageLayoutField(Metadata.LayoutItem item, map<String,String> fieldName2fieldFullNameMap) {
            APIName = fieldName2fieldFullNameMap.get(item.field);
        }
    }

   
}