/// <summary>
/// PageExtensionPTEStkAttributesSORole (ID 50105) extends Record SO Processor Activities.
/// </summary>
pageextension 50105 PTEStkAttributesSORole extends "SO Processor Activities"
{

    trigger OnOpenPage()
    begin
        ShowSetupNotification();
    end;

    /// <summary>
    /// ShowSetupWarning.
    /// </summary>
    local procedure ShowSetupNotification()
    var
        GuidedExperience: Codeunit "Guided Experience";
        SetupNotify: Notification;
        NotificationTextQst: Label 'Stocked Attribute setup is not complete. Do you want to run the wizard?';
        RunWizardTextMsg: Label 'Run Stocked Attribute Setup wizard';
        WizardTok: Label 'RunAssistedSetup';
    begin
        if not GuidedExperience.AssistedSetupExistsAndIsNotComplete(ObjectType::Page, Page::PTEStkAttributeAssistedSetup) then
            exit;

        SetupNotify.Scope(NotificationScope::LocalScope);
        SetupNotify.Message(NotificationTextQst);
        SetupNotify.AddAction(RunWizardTextMsg, Codeunit::PTEStkAttributeMgmt, WizardTok);
        SetupNotify.Send();
    end;

}
