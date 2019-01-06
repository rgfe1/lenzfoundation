public with sharing class GrantReportFormController extends SiteFormController {

  public ApexPages.StandardController sController {get; private set;}
  public Grant_Report__c grantReport {get; private set;}
  public List<GrantReportLineItem> grantReporLineItems {get; private set;}
  public Boolean alreadySubmitted {get; private set;}

  public Blob file { get; set; }
  public String fileName { get; set; }

  public GrantReportFormController(ApexPages.StandardController sController) {
    super();
    this.sController = sController;

    if (!Test.isRunningTest()) {
      sController.addFields(new List<String>{'Grant__c'});
    }

    this.grantReport = (Grant_Report__c)sController.getRecord();
    alreadySubmitted = false;
    setGrantLineItems();
  }

  public override PageReference saveLocal() {
    sController.save();
    saveReportLineItems();
    SiteFormController.saveFile(this.fileName, this.file, grantReport.Id);
    // remove file object from the page state
    file = null;
    this.alreadySubmitted = true;
    PageReference pr = ApexPages.currentPage();
    pr.setRedirect(true);
    return pr;
  }

  @TestVisible
  private void setGrantLineItems() {
    Id grantId = this.grantReport.Grant__c;
    this.grantReporLineItems = new List<GrantReportLineItem>();
    for (Grant_Line_Item__c grantLi : [SELECT Category__c, Amount__c
                                       FROM Grant_Line_Item__c
                                       WHERE Grant__c = :grantId]) {
      this.grantReporLineItems.add(new GrantReportLineItem(grantLi));
    }
  }

  public void saveReportLineItems() {
    List<Grant_Report_Line_Item__c> grantReportLIs=
  						new List<Grant_Report_Line_Item__c>();

  	for (GrantReportLineItem grantReportLi : this.grantReporLineItems) {
      Grant_Report_Line_Item__c grantReportLIObj = new Grant_Report_Line_Item__c();
      grantReportLIObj.Grant_Report_ID__c = sController.getId();
      grantReportLIObj.Grant_Line_Item_ID__c = grantReportLi.grantLi.Id;
      grantReportLIObj.Grant_Amount_Spent__c = grantReportLi.amount;
      grantReportLIs.add(grantReportLIObj);
  	}
    insert grantReportLIs;
  }

  public class GrantReportLineItem {
    public Grant_Line_Item__c grantLi {get;set;}
    public Double amount {get;set;}
    private GrantReportLineItem(Grant_Line_Item__c grantLi) {
      this.grantLi = grantLi;
    }
  }

}