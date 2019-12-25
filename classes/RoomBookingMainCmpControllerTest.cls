@isTest
public class RoomBookingMainCmpControllerTest {
    @isTest static void testRoomBookingMainCmpController() {
        
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
        
        //create reservation(s) 
        Reservation__c Reservation1 = new Reservation__c();
        Reservation1.Name ='qwerty';
        Reservation1.Room__c =Room1.Id;
        Reservation1.StartDate__c = date.parse('05/01/2025');
        Reservation1.EndDate__c = date.parse('05/30/2025');
        Reservation1.Email__c = 'qwerty@azerty.com';
        Reservation1.RecordTypeId = '0122w000000Y1TyAAK';
        insert Reservation1;
        
        Reservation__c Reservation2 = new Reservation__c();
        Reservation2.Name ='qwerty';
        Reservation2.Room__c =Room1.Id;
        Reservation2.StartDate__c = date.parse('04/01/2025');
        Reservation2.EndDate__c = date.parse('04/30/2025');
        Reservation2.Email__c = 'qwerty@azerty.com';
        Reservation2.RecordTypeId = '0122w000000Y1TyAAK';
        insert Reservation2;
        
        Reservation__c Reservation3 = new Reservation__c();
        Reservation3.Name ='qwerty';
        Reservation3.Room__c =Room1.Id;
        Reservation3.StartDate__c = date.parse('06/01/2025');
        Reservation3.EndDate__c = date.parse('06/30/2025');
        Reservation3.Email__c = 'qwerty@azerty.com';
        Reservation3.RecordTypeId = '0122w000000Y1TyAAK';
        insert Reservation3;
        
        Reservation__c Reservation4 = new Reservation__c();
        Reservation4.Name ='qwerty';
        Reservation4.Room__c =Room1.Id;
        Reservation4.StartDate__c = date.parse('04/15/2025');
        Reservation4.EndDate__c = date.parse('05/15/2025');
        Reservation4.Email__c = 'qwerty@azerty.com';
        Reservation4.RecordTypeId = '0122w000000Y1TyAAK';
        insert Reservation4;
        
        Reservation__c Reservation5 = new Reservation__c();
        Reservation5.Name ='qwerty';
        Reservation5.Room__c =Room1.Id;
        Reservation5.StartDate__c = date.parse('05/15/2025');
        Reservation5.EndDate__c = date.parse('06/15/2025');
        Reservation5.Email__c = 'qwerty@azerty.com';
        Reservation5.RecordTypeId = '0122w000000Y1TyAAK';
        insert Reservation5;
        
        List<Hotel__c> HotelList1 = RoomBookingMainCmpController.getHotels('Minsk', 1, 0, 300, date.parse('05/01/2025'), date.parse('05/30/2025'), True, True, True, True, True); 
        
        //check for general correctness
        System.assertEquals(HotelList1.size(), 1);
        System.assertEquals(HotelList1[0].Rooms__r[0].Quantity__c, 2);
        
        //minPrice>maxPrice
        List<Hotel__c> HotelList4 = RoomBookingMainCmpController.getHotels('Minsk', 1, 300, 100, date.parse('05/01/2025'), date.parse('05/30/2025'), True, True, True, True, True); 
        System.assertEquals(HotelList4.size(), 0);
        
        //minPrice<0
        List<Hotel__c> HotelList5 = RoomBookingMainCmpController.getHotels('Minsk', 1, -100, 100, date.parse('05/01/2025'), date.parse('05/30/2025'), True, True, True, True, True); 
        System.assertEquals(HotelList5.size(), 0);
        
        //checkIn>checkOut
        List<Hotel__c> HotelList6 = RoomBookingMainCmpController.getHotels('Minsk', 1, 0, 100, date.parse('05/30/2025'), date.parse('05/01/2025'), True, True, True, True, True); 
        System.assertEquals(HotelList6.size(), 0);
        
        //checkIn<today
        List<Hotel__c> HotelList7 = RoomBookingMainCmpController.getHotels('Minsk', 1, 0, 100, system.today()-1, date.parse('05/01/2030'), True, True, True, True, True); 
        System.assertEquals(HotelList7.size(), 0);
        
    }
}