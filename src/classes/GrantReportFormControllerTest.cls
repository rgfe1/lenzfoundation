@IsTest
private class GrantReportFormControllerTest {

    @IsTest
    static void testSaveLocal() {
        Grant__c grant = new Grant__c();
        grant.Amount__c = 1000;
        grant.Grant_Category__c = 'End of Life Care';
        grant.Grant_Status__c = 'Under Review';
        grant.Grant_Type__c = 'Partnership';
        insert grant;

        Grant_Line_Item__c gli = new Grant_Line_Item__c();
        gli.Category__c = 'Stuff';
        gli.Amount__c = 50;
        gli.Grant__c = grant.Id;
        insert gli;

        Grant_Report__c gr = new Grant_Report__c();
        gr.Submission_Date__c = System.today();
        gr.Grant__c = grant.Id;
        insert gr;

        ApexPages.StandardController stdGrantReport =
                new ApexPages.StandardController(gr);

        // instantiate the controller
        GrantReportFormController grantReportController =
                new GrantReportFormController(stdGrantReport);

        grantReportController.setGrantLineItems();

        // ensure that the object is saved
        grantReportController.verifyAndSave();

    }

    @IsTest
    static void testRecaptchaCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse res = SiteFormController.makeRequest('url', 'body');

        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"success":"true"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    @IsTest
    static void testJsonParser() {
        String val = SiteFormController.getValueFromJSON('{"success":"true"}', 'success');
        System.assert(val == 'true');
    }
}