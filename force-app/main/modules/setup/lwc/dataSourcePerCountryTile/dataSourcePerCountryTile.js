/**
 * Created by jaapbranderhorst on 27/06/2020.
 */

import {LightningElement, api, track} from 'lwc';

export default class DataSourcePerCountryTile extends LightningElement {

    _item;

    @api
    get item() {
        return this._item;
    }
    set item(value) {
        let localValue = {...value};
        this._item = localValue;
        this.selectedDatasource = localValue.selectedDataSource;
        this.options = localValue.dataSourceOptions;
    }

    selectedDataSource;

    options;

    handleDataSourceSelect(event) {
        this.item.selectedDataSource = event.target.value;
    }

}