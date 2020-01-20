public inherited sharing class BusinessAccountingService {
    
    
    public static void onboardCustomer(String username, String password){
        newInstance().onboardCustomer(username, password);
    }

    public static boolean getUserOnboarded(){
        return newInstance().getUserOnboarded();
    }

    public static void saveDataUserCredentials(String username, String password) {
        newInstance().saveDataUserCredentials(username, password);
    }
    
    public static void addBudget(Double amount){ // adds budget to already registered user. as there is only one user in the system we need onl;y the amount param
        newInstance().addBudget(amount);
    }    
    
    public static Double getBalance(){ // get balance for currently active CompanyConnect user in the app
        return newInstance().getBalance();
    }

    public static Boolean userCheckActive(){ // get balance for currently active CompanyConnect user in the app
        return newInstance().userCheckActive();
    }
    
    public static IBusinessAccountingService newInstance() {
        return (IBusinessAccountingService) Application.Service.newInstance(IBusinessAccountingService.class);
    }

}