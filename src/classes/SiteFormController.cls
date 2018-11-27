public with sharing class SiteFormController {

  public ApexPages.StandardController sController {get; private set;}
  public SObject currentObj {get; set;}

  private static String secret = '6LfjUnsUAAAAAE94U98CZ3AklpBGBVP0LNB6aa3m';
  private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';

  public Blob file { get; set; }
  public String fileName { get; set; }

  public String siteKey {get; private set;}
  public Boolean verified { get; private set;}
  public String response {
    get {return ApexPages.currentPage().getParameters().get('g-recaptcha-response');}
  }

  public SiteFormController(ApexPages.StandardController sController) {
    this.sController = sController;
    this.currentObj = sController.getRecord();
    this.siteKey = '6LfjUnsUAAAAADpYMUUZdBYKnCvoskvllPyDKZC2';
    this.verified = false;
  }

  public void saveLocal() {

    // save the form data
    this.sController.save();

    // save file data
    if (this.fileName != null && this.file != null) {
      try {
        ContentVersion v = new ContentVersion();
        v.VersionData = this.file;
        v.Title = this.fileName;
        v.PathOnClient = '/' + this.fileName;
        insert v;
        
        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE ID = :v.Id].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId;
        cdl.LinkedEntityId = this.sController.getId();
        cdl.ShareType = 'V';
        insert cdl;
        
        // remove file object from the page state
        this.file = null;
        
      } catch (Exception e) {
        addMessage(ApexPages.SEVERITY.ERROR,
                'There was an error while uploading a file.' + e.getMessage());
      }

    }

  }

  public PageReference verifyAndSave() {
    
    HttpResponse resp = makeRequest(baseUrl,
            'secret=' + secret + '&response='  + response);

    if (resp != null) {
      String success = getValueFromJSON(resp.getBody(), 'success');
      this.verified = (success != null && success.equalsIgnoreCase('true'));
    }
    
    if(this.verified) {
      saveLocal();
    } else {
      addMessage(ApexPages.Severity.ERROR, 'Could not verify reCaptcha');
    }
    return null;
  }

  private static HttpResponse makeRequest(String url, String body) {
    HttpResponse response = null;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url); req.setMethod('POST');
    req.setBody (body);

    try {
      Http http = new Http();
      response = http.send(req);
    } catch(System.Exception e) {
      addMessage(ApexPages.Severity.ERROR, 'reCAPTCHA ERROR: ' + e.getMessage());
    }

    return response;

  }
  
  private static void addMessage(ApexPages.Severity severity, String message) {
    ApexPages.Message errorMsg = 
        new ApexPages.Message(severity, message);
    ApexPages.addMessage(errorMsg);
  }

  public static String getValueFromJSON(String body, String field) {
    JSONParser parser = JSON.createParser(body);
    while (parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        if (parser.getText() == field) {
          parser.nextToken();
          return parser.getText();
        }
      }
    }
    // field not found
    return null;
  }

}