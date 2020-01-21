/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

public without sharing class PostInstallScript implements InstallHandler {

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // for each previous version a action (aka script) should be added. The actions/scripts handle the previous version specific actions.

    private Map<Version, IInstallAction> upgradeActionsByVersions = new Map<Version, IInstallAction> {
            new Version(2,0) => new v20upgradeScript()
    };

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // the version is the version you install. Use upgradeActionsByVersions if this is an upgrade
    private Map<Version, IInstallAction> installActionsByVersions = new Map<Version, IInstallAction>();

    // the action/script executed when installing the app from scratch
    private IInstallAction installAction = null;

    // the action/script that's always executed when upgrading the app
    private IInstallAction upgradeAction = null;

    public void onInstall(InstallContext context) {
        PostInstallActionExecutor executor = new PostInstallActionExecutor(installAction, upgradeAction, upgradeActionsByVersions, context);
        executor.execute();

        //this script should always run
        GeneralPostInstallScript generalPostInstallScript = new GeneralPostInstallScript();
        generalPostInstallScript.execute(context);
    }

}