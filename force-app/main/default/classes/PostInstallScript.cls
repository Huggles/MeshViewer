/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

public without sharing class PostInstallScript implements InstallHandler {

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // for each previous version a action (aka script) should be added. The actions/scripts handle the previous version specific actions.
    // this map works for the cust_connect namespace/versions
    private Map<Version, IInstallAction> upgradeActionsByPreviousVersionsAppsolutely = new Map<Version, IInstallAction> ();

    // the action/script executed when installing the app from scratch
    @TestVisible
    private IInstallAction installAction = new GeneralPostInstallScript();

    // the action/script that's always executed when upgrading the app
    private IInstallAction upgradeAction = new GeneralPostInstallScript();

    public void onInstall(InstallContext context) {
        PostInstallActionExecutor executor = new PostInstallActionExecutor(installAction, upgradeAction, upgradeActionsByPreviousVersionsAppsolutely, context);
        executor.execute();
    }

}