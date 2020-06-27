/**
 * Created by jaapbranderhorst on 27/06/2020.
 */

import {LightningElement, api} from 'lwc';

export default class DataSourcePerCountryTile extends LightningElement {

    @api item;

    @api
    getSelectedDatasource() {
        return item.selectedDataSource;
    }

    handleDataSourceSelect(event) {
        item.selectedDataSource = event.target.value;
    }

}