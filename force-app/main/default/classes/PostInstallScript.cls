/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

public without sharing class PostInstallScript implements InstallHandler {

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // the version is the NEW version (to which you upgrade). In your install action you have to determine what's the
    // OLD version (from which you are upgrading) to have the right behavior.

    private Map<Version, IInstallAction> upgradeActionsByVersions = new Map<Version, IInstallAction> {
            new Version(2,0) => new v20upgradeScript()
    };

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // the version is the version you install. Use upgradeActionsByVersions if this is an upgrade
    private Map<Version, IInstallAction> installActionsByVersions = new Map<Version, IInstallAction>();

    public void onInstall(InstallContext context) {
        if (context.isUpgrade()) {
            PostInstallActionExecutor upgradeExecutor = new PostInstallActionExecutor(upgradeActionsByVersions, context);
            upgradeExecutor.execute();
        } else {
            PostInstallActionExecutor installExecutor = new PostInstallActionExecutor(installActionsByVersions, context);
            installExecutor.execute();
        }

    }


}