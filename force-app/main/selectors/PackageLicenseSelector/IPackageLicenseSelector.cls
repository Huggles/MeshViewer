/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPackageLicenseSelector extends fflib_ISObjectSelector {

    /**
     * Get the package info based on the id
     * @param packageId The id of the package
     *
     * @return a list of packagelicense wrappers
     */
    PackageLicenseWrapper[] selectById(Id packageId);

}