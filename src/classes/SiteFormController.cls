public abstract with sharing class SiteFormController {

  private static String secret = '6LfjUnsUAAAAAE94U98CZ3AklpBGBVP0LNB6aa3m';
  private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';

  public String siteKey {get; private set;}
  public Boolean verified { get; private set;}
  public String response {
    get {return ApexPages.currentPage().getParameters().get('g-recaptcha-response');}
  }

  public SiteFormController() {
    this.siteKey = '6LfjUnsUAAAAADpYMUUZdBYKnCvoskvllPyDKZC2';
    this.verified = false;
  }

  /** Form-specific implemenation of save */
  public abstract PageReference saveLocal();

  /**
   * Validates captcha and calls saveLocal
   * for the form-specific implementation of save
   */
  public PageReference verifyAndSave() {
    if (Test.isRunningTest()) {
      this.verified = true;
    } else {
      HttpResponse resp = makeRequest(baseUrl,
              'secret=' + secret + '&response=' + response);
      if (resp != null) {
        String success = getValueFromJSON(resp.getBody(), 'success');
        this.verified = (success != null && success.equalsIgnoreCase('true'));
      }
    }

    if(this.verified) {
      saveLocal();
    } else {
      addMessage(ApexPages.Severity.ERROR, 'Please tell us you are not a robot');
    }
    return null;
  }

  public static HttpResponse makeRequest(String url, String body) {
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

  public static void saveFile(String fileName, Blob file, Id recordId) {
    // save file data
    if (fileName != null && file != null) {
      try {
        ContentVersion v = new ContentVersion();
        v.VersionData = file;
        v.Title = fileName;
        v.PathOnClient = '/' + fileName;
        insert v;

        Id contentDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :v.Id].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentDocId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        insert cdl;
      } catch (Exception e) {
        addMessage(ApexPages.Severity.ERROR,
                'There was an error while uploading file.' + e.getMessage());
      }
    }
  }

  public static void addMessage(ApexPages.Severity severity, String message) {
    ApexPages.Message errorMsg =
            new ApexPages.Message(severity, message);
    ApexPages.addMessage(errorMsg);
  }

}