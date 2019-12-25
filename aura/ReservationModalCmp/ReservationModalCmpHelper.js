({
    //server side action to create a reservation
    makeReservation : function(component) {
        
        return new Promise(function(resolve, reject) {
            
            //data for reservation
            var name = component.get('v.nameModal');
            var email = component.get('v.emailModal');
            var checkInDate = component.get('v.checkInDate');
            var checkOutDate = component.get('v.checkOutDate');
            var id = component.get('v.roomIdModal');
            
            //server side action
            var action = component.get('c.makeReservation');
            
            //action parameters
            action.setParams({
                name : name,
                email : email,
                checkInDate : checkInDate,
                checkOutDate : checkOutDate,
                id : id
                
            }); 
            
            //action callback after completion
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    resolve(result);
                } else if (state === "ERROR") {
                    reject(new Error(response.getError()));
                }
            }));
            $A.enqueueAction(action);
        });
    },
    
    //prepare modal window
    prepareModal: function(component, event) {
        var str = event.getParam("str");
        str = str.split('$$$');
        console.log(str);
        
        //set attributes for modal window
        component.set('v.roomIdModal', str[6]);
        component.set('v.hotelModal', str[3]);
        component.set('v.addressModal', str[4]);
        component.set('v.roomModal', str[0] + ' for ' + str[1] +' guests');
        
        var date1 = new Date(component.get('v.checkOutDate'));//mm/dd/yyyy
        var date2 = new Date(component.get('v.checkInDate'));//mm/dd/yyyy
        var timeDiffrence = Math.abs(date2.getTime() - date1.getTime());
        var differDays = Math.ceil(timeDiffrence / (1000 * 3600 * 24));
        component.set('v.totalCostModal', str[2] * differDays);
    },
    
    //open modal window
    openModal: function(component) {
        var modal = component.find('modal');
        var backdrop = component.find('backdrop');
        $A.util.addClass(modal, 'slds-fade-in-open');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
    },
    
    //close modal window
    closeModal: function(component) {
        var modal = component.find('modal');
        var backdrop = component.find('backdrop');
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
    }, 
    
    //open success modal window
    openSuccessModal: function(component) {
        var modal = component.find('successModal');
        var backdrop = component.find('backdrop');
        $A.util.addClass(modal, 'slds-fade-in-open');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
    },
    
    //close success modal window
    closeSuccessModal: function(component) {
        var modal = component.find('successModal');
        var backdrop = component.find('backdrop');
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
    },
    
    //open error modal window
    openErrorModal: function(component) {
        var modal = component.find('errorModal');
        var backdrop = component.find('backdrop');
        $A.util.addClass(modal, 'slds-fade-in-open');
        $A.util.addClass(backdrop, 'slds-backdrop_open');
    },
    
    //close error modal window
    closeErrorModal: function(component) {
        var modal = component.find('errorModal');
        var backdrop = component.find('backdrop');
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(backdrop, 'slds-backdrop_open');
    }
})