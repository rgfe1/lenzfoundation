public with sharing class LetterOfInterestFormController extends SiteFormController {

  public ApexPages.StandardController sController {get; private set;}
  public Boolean alreadySubmitted {get; private set;}
  public Blob file { get; set; }
  public String fileName { get; set; }

  public LetterOfInterestFormController(ApexPages.StandardController sController) {
    super();
    this.sController = sController;
    this.alreadySubmitted = false;
  }

  public override PageReference saveLocal() {
    sController.save();
    alreadySubmitted = true;
    SiteFormController.saveFile(this.fileName, this.file, sController.getId());
    this.alreadySubmitted = true;
    // remove file object from the page state
    file = null;
    PageReference pr = ApexPages.currentPage();
    pr.setRedirect(true);
    return pr;
  }
}