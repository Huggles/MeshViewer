public interface IDutchBusinessAccountingService {

    DutchBusinessAccountingDto.userCreateResponseDto onboardCustomer(String username);
    boolean getUserOnboarded();
    DutchBusinessAccountingDto.userCreateResponseDto createCIUser(DutchBusinessAccountingDto.UserCreateRequestDto input);
    boolean addTrialToCIUser(DutchBusinessAccountingDto.userCreateResponseDto userId);
    boolean addBudget(Double amount, Integer userId);
    boolean addBudget(Double amount); // adds budget to already registered user. as there is only one user in the system we need onl;y the amount param
    Double getBalance(); // get balance for currently active CompanyInfo user in the app
}
