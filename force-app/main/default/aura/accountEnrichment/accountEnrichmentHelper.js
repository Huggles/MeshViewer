/**
 * Created by jaapbranderhorst on 29/02/2020.
 */

({  /**
     * Call Apex Method
     * @param {*} component
     * @param {string} methodName The name of the apex method to call
     * @param {object} params An object containing the arguments to pass to the apex method
     * @param {function} callback A js function to be called on successful response from apex
     * @param {*} stubResponse To be removed, response to stub calls (to avoid costly API calls).
     */
    callServer : function(component, methodName, params, callback, stubResponse) {

        // @todo remove after development
        if (stubResponse) {
            callback(stubResponse);
            return;
        }

        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var _this = this;
        var action = component.get(methodName);
        action.setParams(params);

        // Create a callback that is executed after
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().state ==="SUCCESS"){
                    callback(response.getReturnValue().response);
                }else{
                    _this.showToast(component, response.getReturnValue().errorMsg);
                }
            }
            else if (state === "INCOMPLETE") {
                _this.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Incomplete'), 'error');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    _this.showToast(component, errors[0].message);
                } else {
                    _this.showToast(component, $A.get('$Label.c.Error'), $A.get('$Label.c.Error_Unknown'), 'error');
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events,
        // which could trigger other events and
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    /**
     * Fire toast event
     * @param {*} component
     * @param {*} title
     * @param {*} message
     * @param {*} type success/error/info
     */
    showToast : function(component, title, message, type, mode) {
        component.find('notifLib').showToast({
            "title": title,
            "message":message,
            "variant": (type == null ? 'info' : type),
            "mode": (mode == null ? ((type == 'info' || type == 'success' || type == null) ? 'dismissable' : 'sticky') : mode)
        });
    },
    /**
     * Starts the flow with the attribute name 'flowName'
     * @param component
     */
    startFlow: function(component) {
        var flow = component.find("flowData");
        if (flow) {
            var inputVariables = [
                {
                    name : 'recordId',
                    type : 'String',
                    value : component.get("v.recordId")
                }
            ];
            flow.startFlow(component.get("v.flowName"), inputVariables);
        }
    }
});