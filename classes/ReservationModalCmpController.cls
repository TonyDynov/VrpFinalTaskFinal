public class ReservationModalCmpController {
    
    //create reservation based on stated data
    @AuraEnabled public static Boolean makeReservation(String name, String email, Date checkInDate, Date checkOutDate, String id) {
        
        //set reservation fields
        Reservation__c res = new Reservation__c();
        res.Room__c = id;
        res.StartDate__c = checkInDate;
        res.EndDate__c = checkOutDate;
        res.Email__c = email;
        Room__c Room = [SELECT Name, Guests__c, Hotel__r.Name FROM Room__c WHERE Id=:id LIMIT 1];
        res.Name= '' + name + ' ' + Room.Name + ' for ' + Room.Guests__c + ' ' + ' in ' + Room.Hotel__r.Name + ' ' + checkInDate.format() + ' - ' + checkOutDate.format();
        res.RecordTypeId = '0122w000000XzWOAA0';
        
        //try to insert reservation
        Database.SaveResult result = Database.insert(res, false);
        
        //if reservation is was inserted successfully, send confirmation email
        if(result.isSuccess() == true) {
            ReservationModalCmpController.sendConfirmationEmail(email, name, checkInDate, checkOutDate, id);
        }
        
        //return results of insertion attempt
        return result.isSuccess();
    }
    
    //send confirmation email after reservation is created succesfully
    public static void sendConfirmationEmail (String EmailAddress, String Name, Date checkInDate, Date checkOutDate, String RoomId) {
        
        Messaging.reserveSingleEmailCapacity(1);
        
        Messaging.SingleEmailMessage Mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {EmailAddress}; 
            String[] ccAddresses = new String[] {EmailAddress};
                
                mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        
        mail.setReplyTo('support@bookaroom.com');
        
        mail.setSenderDisplayName('Bookaroom Support');
        
        mail.setSubject('Reservation confirmation letter');
        
        mail.setBccSender(false);
        
        mail.setUseSignature(false);
        
        Room__c Room = [SELECT Name, Guests__c, Hotel__r.Name, Hotel__r.Address__c FROM Room__c WHERE Id = :RoomId];
        
        mail.setHtmlBody('<p><strong>' +Name + '</strong>, Your reservation was registered successfully!</p>'
                         +'<p>Hotel: ' + Room.Hotel__r.Name + ', ' + Room.Hotel__r.Address__c + '</p>'
                         +'<p>Room: ' + Room.Name + ' for ' + Room.Guests__c + '</p>'
                         +'<p>Check-in date: ' + checkInDate.format() + '</p>'
                         +'<p>Check-out date: ' + checkOutDate.format() + '</p>');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}