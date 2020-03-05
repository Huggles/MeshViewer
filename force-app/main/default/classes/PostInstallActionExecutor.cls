/**
 * Created by jaapbranderhorst on 05/10/2019.
 */

public without sharing class PostInstallActionExecutor {
    // actions to execute during upgrade. The keys contain the versions from which we are upgrading (previous version)
    private Map<Version, IInstallAction> upgradeActionsByVersion { get; set; }

    // the instal context
    private InstallContext context { get; set; }

    // the action/script that is run when the app is installed the first time
    private IInstallAction installAction { get; set; }

    // the action/script that's executed always when upgrading. Is always executed before the other upgrade actions
    private IInstallAction upgradeAction { get; set; }

    public PostInstallActionExecutor(IInstallAction installAction, IInstallAction upgradeAction, Map<Version, IInstallAction> upgradeActionsByVersion, InstallContext context) {
        this.installAction = installAction;
        this.upgradeAction = upgradeAction;
        this.upgradeActionsByVersion = upgradeActionsByVersion;
        this.context = context;
    }

    public void execute() {
        if (context.isUpgrade()) {
            if (upgradeAction != null) {
                upgradeAction.execute(context);
            }
            Version previousVersion = context.previousVersion();
            IInstallAction action = upgradeActionsByVersion.get(previousVersion);
            if (action != null)
                action.execute(context);
        } else {
            if (installAction != null) {
                installAction.execute(context);
            }
        }
    }

}