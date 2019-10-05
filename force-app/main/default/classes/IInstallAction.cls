/**
 * Created by jaapbranderhorst on 05/10/2019.
 */

/**
 * During the postinstall actions that implement this interface are executed
 */
public interface IInstallAction {
    void execute(InstallContext context);
}