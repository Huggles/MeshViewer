public with sharing class DutchBusinessAccountingService {
    
    
    public static DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String username){
        return newInstance().onboardCustomer(username);
    }
    public static boolean getUserOnboarded(){
        return newInstance().getUserOnboarded();
    }
    public static DutchBusinessAccountingDto.userCreateResponseDto createCIUser(DutchBusinessAccountingDto.UserCreateRequestDto input){
        return newInstance().createCIUser(input);
    }
    
    public static boolean addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId){
        return newInstance().addTrialToCIUser(userId);
    }
    
    public static boolean addBudget(Double amount, Integer userId){
        return newInstance().addBudget(amount, userId);
    }
    
    public static boolean addBudget(Double amount){ // adds budget to already registered user. as there is only one user in the system we need onl;y the amount param
        return newInstance().addBudget(amount);
    }    
    
    public static Double getBalance(){ // get balance for currently active CompanyInfo user in the app
        return newInstance().getBalance();
    }

    public static Boolean userCheckActive(){ // get balance for currently active CompanyInfo user in the app
        return newInstance().userCheckActive();
    }
    
    public static IDutchBusinessAccountingService newInstance() {
        return (IDutchBusinessAccountingService) Application.Service.newInstance(IDutchBusinessAccountingService.class);
    }

}