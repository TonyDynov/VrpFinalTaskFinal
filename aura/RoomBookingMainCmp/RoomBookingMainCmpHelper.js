({
    //server side action to retrieve all hotels for chosen city & their rooms, if they fit description
    getData : function(component) {
        
        return new Promise(function(resolve, reject) {
            
            //search parameters
            var city = component.get('v.city');
            var guests = component.get('v.guests');
            var minPrice = component.get('v.minPrice');
            var maxPrice = component.get('v.maxPrice');
            var checkInDate = component.get('v.checkInDate');
            var checkOutDate = component.get('v.checkOutDate');
            
            var wiFi = component.get('v.wiFi');
            var miniBar = component.get('v.miniBar');
            var noSmoking = component.get('v.noSmoking');
            var airConditioner = component.get('v.airConditioner');
            var roomService = component.get('v.roomService');
            
            //server side action
            var action = component.get('c.getHotels');
            
            //action parameters
            action.setParams({
                city : city,
                guests : guests,
                minPrice : minPrice,
                maxPrice : maxPrice,
                checkInDate : checkInDate,
                checkOutDate : checkOutDate,
                
                wiFi : wiFi,
                miniBar : miniBar,
                noSmoking : noSmoking,
                airConditioner : airConditioner,
                roomService : roomService
            }); 
            
            //action callback after completion
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    //remove fully occupied types of rooms and fully occupied hotels
                    
                    for (let hotel of result) {
                        if (hotel.Rooms__r != null) {
                            for (let room of hotel.Rooms__r) {
                                if (room.Quantity__c < 1) {
                                    hotel.Rooms__r.splice(hotel.Rooms__r.indexOf(room) ,1);
                                }  
                            }     
                            if (hotel.Rooms__r.length == 0) {
                                result.splice(result.indexOf(hotel) ,1);
                            }
                        } else {
                            result.splice(result.indexOf(hotel) ,1);
                        }    
                    }
                    resolve(result);
                } else if (state === "ERROR") {
                    reject(new Error(response.getError()));
                }
            }));
            $A.enqueueAction(action);
            
        });
    },
    
    //unhide pagination & main section
    showResults : function(component) {
        var paginationTop = component.find("pagination-top");
        var paginationBottom = component.find("pagination-bottom");
        var main = component.find("main");
        
        $A.util.removeClass(paginationTop, 'slds-hide');
        $A.util.removeClass(paginationBottom, 'slds-hide');
        $A.util.removeClass(main, 'slds-hide');
    },
    
    //collapse main section & pagination
    collapseResults : function(component) {
        var paginationTop = component.find("pagination-top");
        var paginationBottom = component.find("pagination-bottom");
        var main = component.find("main");
        
        $A.util.addClass(paginationTop, 'page-item_collapsed');
        $A.util.addClass(paginationBottom, 'page-item_collapsed');
        $A.util.addClass(main, 'page-item_collapsed');
    },
    
    //uncollapse main section & pagination
    unCollapseResults : function(component) {
        var paginationTop = component.find("pagination-top");
        var paginationBottom = component.find("pagination-bottom");
        var main = component.find("main");
        
        $A.util.removeClass(paginationTop, 'page-item_collapsed');
        $A.util.removeClass(paginationBottom, 'page-item_collapsed');
        $A.util.removeClass(main, 'page-item_collapsed');
    },
    
    //collapse spinner
    collapseSpinner : function(component) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, 'spinner-container_collapsed');
    },
    
    //uncollapse spinner
    unCollapseSpinner : function(component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, 'spinner-container_collapsed');
    }, 
    
    //collapse error message
    collapseErrorMessage : function(component) {
        var ErrorMessage = component.find("error-message");
        $A.util.addClass(ErrorMessage, 'error-message_collapsed');
    },
    
    //uncollapse error message
    unCollapseErrorMessage : function(component) {
        var ErrorMessage = component.find("error-message");
        $A.util.removeClass(ErrorMessage, 'error-message_collapsed');
    }
})