({	
    //init
    init : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        component.set('v.checkInDate', today);
        
        var tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        tomorrow = $A.localizationService.formatDate(tomorrow, "YYYY-MM-DD");
        component.set("v.checkOutDateMin", tomorrow);
    },
    
    //handle check-in date change
    handleCheckInChange : function(component, event, helper) {
        var checkInDate = component.get('v.checkInDate');
        checkInDate = $A.localizationService.formatDate(checkInDate, "YYYY-MM-DD");
        var nextDay = new Date(checkInDate);
        nextDay.setDate(nextDay.getDate() + 1);
        nextDay = $A.localizationService.formatDate(nextDay, "YYYY-MM-DD");
        component.set("v.checkOutDateMin", nextDay);
    },
    
    //handle search button press
    handleSearch : function(component, event, helper) {
        
        // Check validity
        var allValid = component.find('validity-check').reduce(function (validFields, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        
        //protection from data mutation
        if(component.get('v.minPrice') == ''){
            component.set('v.minPrice', null);
        }
        
        if(component.get('v.maxPrice') == ''){
            component.set('v.maxPrice', null);
        }
        
        //if all inputs are valid, procede with the action
        if(allValid == true) {
            
            //collapse header to compact form after first search
            var header = component.find("header");
            $A.util.addClass(header, 'header-collapsed');
            
            //make elements visible after first search
            helper.showResults(component);
            
            //disable search button after press
            var searchButton = component.find("searchButton");
            searchButton.set("v.disabled", true);
            
            //1st stage of animation
            helper.collapseResults(component);
            helper.unCollapseSpinner(component);
            helper.collapseErrorMessage(component);
            
            //promise to handle action
            const promise = helper.getData(component);
            
            //handling successful action result
            promise.then( function successCallback(result){
                console.log('search successful');
                component.set('v.hotels', result);
                
                if (result != undefined) {
                    component.set('v.hotelsNumber', result.length);
                } else {
                    component.set('v.hotelsNumber', 0);
                }
                
                let roomsNumber = 0;
                if (result != undefined) {
                    for (let hotel of result) {
                        roomsNumber += hotel.Rooms__r.length;   
                    }              
                }
                
                component.set('v.roomsNumber', roomsNumber);
                
                //2nd stage of animation
                helper.collapseSpinner(component);
                if(roomsNumber!=0){
                    helper.unCollapseResults(component);
                } else {
                    helper.unCollapseErrorMessage(component);
                    component.set('v.hotels', []);
                }
            });
            
            //handling action error
            promise.catch( function errorCallback(errors){
                console.error(errors);
                component.set('v.hotels', []);
            });
            
            //handling any outcome of promise
            promise.finally( function Callback(){
                //enable search button again
                searchButton.set("v.disabled", false);
                helper.collapseSpinner(component);
            });
            
        } else {
            console.log('invalid inputs');
        }
    }
})