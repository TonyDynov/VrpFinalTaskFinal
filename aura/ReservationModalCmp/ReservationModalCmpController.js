({
    
    //handle reservation button click event
    handleReservationButtonClickEvt: function(component, event, helper) {
        console.log('handling event!');
        helper.prepareModal(component,event);
        helper.openModal(component);
    },
    
    //create a reservation
    registerReservation: function(component, event, helper) {
        
        //check validity
        var emailInput = component.find('email-modal');
        var allValid = emailInput.get('v.validity').valid;
        emailInput.showHelpMessageIfInvalid();
        
        //if all inputs are valid, procede with the action
        if(allValid == true) {
            
            //start loading animation
            $A.util.removeClass(component.find('spinnerModal'), 'page-item_collapsed'); 
            $A.util.addClass(component.find('modalInfo'), 'page-item_collapsed');   
            
            //disable button after press
            var button = component.find("modalReservationButton");
            button.set("v.disabled", true);
            
            //promise to handle action
            const promise = helper.makeReservation(component);
            
            //handling successful action result
            promise.then( function successCallback(result){
                console.log('results of attempt came');
                if (result == true) {
                    console.log('reservation created successfully');
                    helper.closeModal(component);
                    helper.openSuccessModal(component);
                } else {
                    console.log('reservation attempt failed');
                    helper.closeModal(component);
                    helper.openErrorModal(component);
                }
            });
            
            //handling action error
            promise.catch( function errorCallback(errors){
                console.log('reservation action promise failed');
                console.error(errors);
                helper.closeModal(component);
                helper.openErrorModal(component);
            });
            
            //handling any outcome of promise
            promise.finally( function Callback(){
                
                //stop loading animation
                $A.util.addClass(component.find('spinnerModal'), 'page-item_collapsed'); 
                $A.util.removeClass(component.find('modalInfo'), 'page-item_collapsed');   
                
                //enable button back
                button.set("v.disabled", false);
            });
        }
    }, 
    
    //close modal window
    closeModal: function(component, event, helper) {
        helper.closeModal(component);
    },
    
    closeSuccessModal : function(component, event, helper) {
        helper.closeSuccessModal(component);
    },
    
    closeErrorModal : function(component, event, helper) {
        helper.closeErrorModal(component);
    }
})