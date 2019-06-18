/****************************************************************************************
Author          : ValerijsProkudins

TODO: update user search with SOSL
******************************************************************************************/
public with sharing class UserSelector extends fflib_SObjectSelector implements IUserSelector {
    public UserSelector() {
//        super(false, // Do not include FieldSet fields
//                true,  // enforce Object level security
//                true); // enforce Field level security
    }

    public static IUserSelector newInstance() {
        return (IUserSelector) Application.Selector.newInstance(User.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User.Id,
                User.Name,
                User.ProfileId,
                User.Email,
                User.isActive
        };
    }

    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }

    /**
     * Select User by Name Like searchKey
     */
    public List<User> selectByNameLikeSearchKey(String searchKey, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        // queryFactory.setEnforceFLS(true);
        system.debug(searchKey + ' isblanc = '+ String.isBlank(searchKey));
        if(!String.isBlank(searchKey)){
            searchKey = '%' + searchKey + '%';

            queryFactory.setCondition('(Name LIKE :searchKey) AND( NOT Name LIKE \'Automated Process\') AND (NOT Name LIKE \'Data.com Clean\')');
            queryFactory.setLimit(20);
        }else{
            queryFactory.setCondition('(NOT Name LIKE \'Automated Process\') AND( NOT Name LIKE \'Data.com Clean\')');
            queryFactory.setLimit(20);
        }
       
        system.debug('sortedDirection' + sortedBy);
        system.debug('sortedDirection' + sortedDirection);
        if(sortedBy == 'ProfileName'){sortedBy = 'Profile.name';}
        if(sortedDirection == 'asc'){
            
            queryFactory.setOrdering(sortedBy, fflib_QueryFactory.SortOrder.ASCENDING);
            //queryFactory.addOrdering(sortedBy, fflib_QueryFactory.SortOrder.ASCENDING);
        }else{
            queryFactory.setOrdering(sortedBy, fflib_QueryFactory.SortOrder.DESCENDING);
        }
   
        List<User> result = Database.query(queryFactory.toSOQL());
        return result;
    }
    /**
     * Select User by Profile Name Like searchKey
     */
    public List<User> selectByProfileLikeSearchKey(String searchKey, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        // queryFactory.setEnforceFLS(true);
        if(!String.isBlank(searchKey)){
            searchKey = '%' + searchKey + '%';
            queryFactory.setCondition('(Profile.name LIKE :searchKey) AND( NOT Name LIKE \'Automated Process\') AND (NOT Name LIKE \'Data.com Clean\')');
            queryFactory.setLimit(20);
        }else{
            queryFactory.setCondition('(NOT Name LIKE \'Automated Process\') AND( NOT Name LIKE \'Data.com Clean\')');
            queryFactory.setLimit(20);
        }
        List<User> result = Database.query(queryFactory.toSOQL());
        return result;
    }
}