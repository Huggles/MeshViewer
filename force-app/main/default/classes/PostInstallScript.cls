/**
 * Created by jaapbranderhorst on 2019-07-16.
 */

public without sharing class PostInstallScript implements InstallHandler {

    @TestVisible
    private final static String CUST_CONNECT_NAMESPACE_PREFIX = 'cust_connect';

    @TestVisible
    private final static String APPSOLUTELY_NAMESPACE_PREFIX = 'appsolutely';

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // for each previous version a action (aka script) should be added. The actions/scripts handle the previous version specific actions.
    // this map works for the cust_connect namespace/versions

    private Map<Version, IInstallAction> upgradeActionsByPreviousVersionsCustConnect = new Map<Version, IInstallAction> {
            new Version(1,7) => new v20upgradeScript()
    };

    // add actions that implement the IInstallAction interface to this map to have them executed on post install
    // for each previous version a action (aka script) should be added. The actions/scripts handle the previous version specific actions.
    // this map works for the cust_connect namespace/versions
    private Map<Version, IInstallAction> upgradeActionsByPreviousVersionsAppsolutely = new Map<Version, IInstallAction> ();

    // the action/script executed when installing the app from scratch
    private IInstallAction installAction = new GeneralPostInstallScript();

    // the action/script that's always executed when upgrading the app
    private IInstallAction upgradeAction = new GeneralPostInstallScript();

    // The namespace this package has. As property for test purposes.
    private String nameSpace;

    @TestVisible
    private PostInstallScript(String nameSpace) {
        this.nameSpace = nameSpace;
    }

    public PostInstallScript() {
        ApexClass apexClass = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'PostInstallScript'];
        System.debug('Namespace: ' + apexClass.NamespacePrefix);
        this.nameSpace = apexClass.NamespacePrefix;
    }

    public void onInstall(InstallContext context) {
        PostInstallActionExecutor executor = null;
        if (nameSpace == CUST_CONNECT_NAMESPACE_PREFIX) {
             executor = new PostInstallActionExecutor(installAction, upgradeAction, upgradeActionsByPreviousVersionsCustConnect, context);
        } else {
             executor = new PostInstallActionExecutor(installAction, upgradeAction, upgradeActionsByPreviousVersionsAppsolutely, context);
        }
        executor.execute();
    }

}