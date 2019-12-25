public class RoomBookingMainCmpController {
    
    //get list of hotels and rooms
    @AuraEnabled public static List<Hotel__c> getHotels(String city, Integer guests, Integer minPrice, Integer maxPrice, Date checkInDate, Date checkOutDate, Boolean wiFi, Boolean miniBar, Boolean airConditioner, Boolean roomService, Boolean noSmoking) {
        
        List<Hotel__c> HotelList = new List<Hotel__c>();
        
        //abort method if some of the inputs are critically imvalid
        if(minPrice<0 || minPrice > maxPrice || checkInDate > checkOutDate || checkInDate < system.today()) {
            return HotelList;
        }
        
        //start soql query
        String SoqlQuery = ' SELECT Name,City__c,Address__c,StarRating__c, (SELECT Name, Guests__c, NightlyRate__c, WiFi__c, RoomService__c, MiniBar__c, NoSmoking__c, AirConditioner__c, Hotel__c, Image__c, Quantity__c FROM Rooms__r WHERE ';
        
        //add guests condition to query
        SoqlQuery += ' Guests__c >= :guests ';
        if (maxPrice != null || minPrice != null || wiFi == true || miniBar == true  || airConditioner == true || noSmoking == true || roomService == true) {
            SoqlQuery += ' AND ';
        }
        
        //add minimal price condition to query 
        if (minPrice != null) {
            SoqlQuery += ' NightlyRate__c >= :minPrice ';
            //add 'AND'
            if (maxPrice != null || wiFi == true || miniBar == true  || airConditioner == true || noSmoking == true || roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add maximal price condition to query 
        if (maxPrice != null) {
            SoqlQuery += ' NightlyRate__c <= :maxPrice ';
            //add 'AND'
            if (wiFi == true || miniBar == true  || airConditioner == true || noSmoking == true || roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add Wi-Fi condition to query 
        if (wiFi == true) {
            SoqlQuery += ' WiFi__c = true ';
            //add 'AND'
            if (miniBar == true  || airConditioner == true || noSmoking == true || roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add minibar condition to query 
        if (miniBar == true) {
            SoqlQuery += ' MiniBar__c = true ';
            //add 'AND'
            if (airConditioner == true || noSmoking == true || roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add air conditioner condition to query 
        if (airConditioner == true) {
            SoqlQuery += ' AirConditioner__c = true ';
            //add 'AND'
            if (noSmoking == true || roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add no smoking condition to query 
        if (noSmoking == true) {
            SoqlQuery += ' NoSmoking__c = true ';
            //add 'AND'
            if (roomService == true) {
                SoqlQuery += ' AND ';
            }
        }
        
        //add room service condition to query 
        if (roomService == true) {
            SoqlQuery += ' RoomService__c = true ';
        }
        
        //finish query
        SoqlQuery +=  ' ORDER BY NightlyRate__c DESC) FROM Hotel__c WHERE City__c = :city';
        
        HotelList = database.query(soqlQuery);    
        
        //get a list of room id's to query reservations all at once
        List<String> IdList = new List<String>();
        
        for(Hotel__c Hotel: HotelList){ 
            for(Room__c Room : Hotel.Rooms__r) {
                IdList.add(Room.Id);
            }
        }
        
        //get a list of reservations overlapping with selected time period for all queried rooms
        List<Reservation__c>  ReservationList = [SELECT StartDate__c, EndDate__c, Room__c FROM Reservation__c WHERE Room__c IN :IdList AND(NOT((EndDate__c < :checkInDate AND StartDate__c < :checkInDate) OR (StartDate__c > :checkOutDate AND EndDate__c > :checkOutDate))) AND RecordTypeId = '0122w000000Y1TyAAK'];

        //check if there are free rooms of that type left 
        for(Hotel__c Hotel: HotelList){ 
            
            for(Room__c Room : Hotel.Rooms__r) {
                
                //check every day of searched time range to find the day with highest amount of reservations for the room type
                if (ReservationList.size() > 0) {
                    Integer MaxReservationQuantity = 0;
                    for (Date dt = checkInDate; dt.daysBetween(checkOutDate) > 0; dt = dt.addDays(1)) {
                        Integer CurrentDayReservationQuantity = 0;
                        for (Reservation__c res : ReservationList) {
                            if (res.Room__c == Room.Id &&(res.EndDate__c.daysBetween(dt) <= 0 || res.StartDate__c.daysBetween(dt) >= 0)) {
                                CurrentDayReservationQuantity++;
                            }
                        }
                        if (CurrentDayReservationQuantity > MaxReservationQuantity) {
                            MaxReservationQuantity = CurrentDayReservationQuantity;
                        }
                    }
                    //final returned quantity of returned room type equals (full Quantity - max(fitting reservations)) 
                    Room.Quantity__c -= MaxReservationQuantity;
                }
            }
        }
        return HotelList;
    }
}