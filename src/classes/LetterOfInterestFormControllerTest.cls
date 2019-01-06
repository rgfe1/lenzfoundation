@IsTest
private class LetterOfInterestFormControllerTest {

    @IsTest
    static void testSaveLocal() {
        Letter_Of_Interest__c loi = new Letter_Of_Interest__c();
        loi.Amount__c = 2000;
        loi.Email__c = 'grantee@email.com';
        loi.Grant_Request_Date__c = System.today().addDays(20);
        loi.Main_Contact__c = 'Melinda Gates';
        loi.Organization_Name__c = 'Be Spiritual Now!';
        loi.Phone_Number__c = '415-111-2222';
        loi.Qualified_Tax_Exempt_NGO_501c3_IRS__c = 'Yes';
        loi.State__c = 'Georgia';
        loi.Street_Address__c = 'address';
        loi.Website_URL__c = 'www.bsn.com';
        loi.Zip_Code__c = '12345';
        loi.City__c = 'Atlanta';

        ApexPages.StandardController stdLoi =
                new ApexPages.StandardController(loi);

        // instantiate the controller
        LetterOfInterestFormController loiController =
                new LetterOfInterestFormController(stdLoi);

        // ensure that the object is saved
        loiController.verifyAndSave();

        System.assert(loiController.alreadySubmitted);
        System.assert(loiController.file == null);
        System.assert(loiController.sController.getId() != null);
    }
}