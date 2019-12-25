@isTest
public class ReservationModalCmpControllerTest {
    @isTest static void testReservationModalCmpController() {
        
        //create hotel(s)
        Hotel__c Hotel = new Hotel__c();
        Hotel.Name = 'Hotel';
        Hotel.City__c ='Minsk';
        Hotel.Address__c = 'qwerty';
        Hotel.StarRating__c = '5';
        insert Hotel;
        
        //create room(s)
        Room__c Room1 = new Room__c();
        Room1.Hotel__c = Hotel.Id;
        Room1.Name = 'qwertty';
        Room1.Guests__c = 1;
        Room1.NightlyRate__c = 99;
        Room1.AirConditioner__c = True;
        Room1.RoomService__c = True;
        Room1.NoSmoking__c = True;
        Room1.WiFi__c = True;
        Room1.MiniBar__c = True;
        Room1.Quantity__c = 5;
        insert Room1;
        
        Boolean result1 = ReservationModalCmpController.makeReservation('qwerty', 'qwerty@azerty.com', date.parse('05/01/2025'), date.parse('05/30/2025'), Room1.Id);
        
        System.assertEquals(result1, true);
    }
}