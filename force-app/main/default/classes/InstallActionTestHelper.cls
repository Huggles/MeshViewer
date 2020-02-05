/**
 * Created by jaapbranderhorst on 04/02/2020.
 */

/**
 * Helper class to make it easy to test instalactions within the context of a 'fake' postinstall script (being this class)
 */
public with sharing class InstallActionTestHelper implements InstallHandler {

    private IInstallAction action;

    public InstallActionTestHelper(IInstallAction action) {
        this.action = action;
    }

    public void onInstall(InstallContext context) {
        action.execute(context);
    }


}