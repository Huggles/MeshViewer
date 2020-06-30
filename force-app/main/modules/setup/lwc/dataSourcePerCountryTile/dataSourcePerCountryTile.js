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
        this.options = localValue.dataSourceOptions;
    }

    @api
    get selectedDataSource() {
        if (this._item) {
            return this._item.selectedDataSource;
        } else {
            return null;
        }
    }

    @api
    get countryCode() {
        if (this._item) {
            return this._item.countryCode;
        } else {
            return null;
        }
    }

    @track
    options;

    handleDataSourceSelect(event) {
        this._item.selectedDataSource = event.target.value;
    }

}