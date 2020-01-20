/**
 * Created by jaapbranderhorst on 05/10/2019.
 */

public without sharing class PostInstallActionExecutor {
    private Map<Version, IInstallAction> actionsByVersion { get; set; }
    private InstallContext context { get; set; }

    public PostInstallActionExecutor(Map<Version, IInstallAction> actionsByVersion, InstallContext context) {
        this.actionsByVersion = actionsByVersion;
        this.context = context;
    }

    public void execute() {
        System.debug('in execute');
        for (Version version : actionsByVersion.keySet()) {
            System.debug('version: ' + version);
            IInstallAction action = actionsByVersion.get(version);
            action.execute(context);
        }
    }

}