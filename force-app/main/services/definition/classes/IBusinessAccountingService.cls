public interface IBusinessAccountingService {

    DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String username, String password);
    boolean getUserOnboarded();
    DutchBusinessAccountingDto.userCreateResponseDto createCIUser(DutchBusinessAccountingDto.UserCreateRequestDto input);
    boolean addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId);
    boolean addBudget(Double amount, Integer userId); // TODO: replace the Integer with a String. Integers should never be used for ids
    boolean addBudget(Double amount); // adds budget to already registered user. as there is only one user in the system we need onl;y the amount param
    Double getBalance(); // get balance for currently active CompanyConnect user in the app
    Boolean userCheckActive(); // determine if the CompanyConnect user is currently active
}
