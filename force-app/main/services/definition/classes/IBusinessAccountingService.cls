public interface IBusinessAccountingService {

//    /**
//     * Creates a new resell trial user and adds trial budget
//     *
//     * @param username
//     * @param password
//     */
//    void onboardCustomer(String username, String password);

//    boolean getUserOnboarded();

    /**
     * Saves the credentials of the data user and retrieves + saves the userid for the given user
     *
     * @param username
     * @param password
     */
    void saveDataUserCredentials(String username, String password);

//    /**
//     * Adds budget to the Company info user. TODO: research if this should also be added to the account if it is a referall account
//     *
//     * @param amount
//     */
//    void addBudget(Double amount);

    /**
     * Returns the balance of the current user
     *
     * @return
     */
    Double getBalance(); // get balance for currently active CompanyConnect user in the app

    Boolean userCheckActive(); // determine if the CompanyConnect user is currently active
}
