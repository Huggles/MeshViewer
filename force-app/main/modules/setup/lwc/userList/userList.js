/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {api, LightningElement} from 'lwc';

export default class UserList extends LightningElement {

    /**
     * The list of users to show
     */
    @api
    users;

}