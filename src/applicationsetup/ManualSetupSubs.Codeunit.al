/// <summary>
/// Codeunit SCI002ManualSetupSubs (ID 70229343).
/// </summary>
codeunit 50105 StockedAttributeSetupSubs
{
    /// <summary>
    /// GuidedExperience_OnRegisterManualSetup.
    /// </summary>
    /// <param name="sender">Codeunit "Guided Experience".</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterManualSetup', '', true, false)]
    local procedure GuidedExperience_OnRegisterManualSetup(sender: Codeunit "Guided Experience")
    begin
        AddDirectDebitManualSetup(Sender);
    end;

    /// <summary>
    /// AddDirectDebitManualSetup.
    /// </summary>
    /// <param name="GuidedSetup">VAR Codeunit "Guided Experience".</param>
    local procedure AddDirectDebitManualSetup(var GuidedSetup: Codeunit "Guided Experience")
    var
        Info: ModuleInfo;
        ManualSetupCategory: Enum "Manual Setup Category";
        SetupTxt: Label 'Stocked Attributes Setup';
        SetupDescTxt: Label 'Set up Stocked Attributes extension functionality.';
        SetupKeywordsTxt: Label 'Stocked Attributes, Dave';
    begin
        NavApp.GetCurrentModuleInfo(Info);
        GuidedSetup.InsertManualSetup(SetupTxt, SetupTxt, SetupDescTxt, 1000, ObjectType::Page, Page::StockedAttributeSetup, ManualSetupCategory::Finance, SetupKeywordsTxt);
    end;
}
