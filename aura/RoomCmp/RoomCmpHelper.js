({
    //fire event with gathered date
    fireEvent: function(component, event) {
        var evt = $A.get("e.c:ReservationButtonClickEvt");
        var str = event.getSource().get("v.value");
        evt.setParams({"str" : str});
        console.log('firing event...');
        evt.fire();
    },
})