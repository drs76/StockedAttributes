/// <summary>
/// Codeunit StkAttributeAssistedSetupSubs (ID 50106).
/// Subcriptions to Assisted Setup codeunit.
/// </summary>
codeunit 50106 StkAttributeAssistedSetupSubs
{
    /// <summary>
    /// AssistedSetup_OnRegister.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, false)]
    local procedure AssistedSetup_OnRegister()
    begin
        AddStockedAttributeSetup();
    end;

    /// <summary>
    /// AddDirectDebitSetup.
    /// </summary>
    local procedure AddStockedAttributeSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        Language: Codeunit Language;
        GuidedExperienceType: Enum "Guided Experience Type";
        Info: ModuleInfo;
        CurrentGlobalLanguage: Integer;
        SetupTxt: Label 'Stocked Attributes Setup';
        SetupDescTxt: Label 'Set up Stocked Attributes extension functionality.';
        EmptyTxt: Label '';
    begin
        if GuidedExperience.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::PTEStkAttributeAssistedSetup) then
            exit;

        NavApp.GetCurrentModuleInfo(Info);
        CurrentGlobalLanguage := GlobalLanguage();
        GuidedExperience.InsertAssistedSetup(SetupTxt, SetupTxt, SetupDescTxt, 10000, ObjectType::Page, Page::PTEStkAttributeAssistedSetup, "Assisted Setup Group"::ReadyForBusiness, EmptyTxt, "Video Category"::Uncategorized, EmptyTxt);

        GlobalLanguage(Language.GetDefaultApplicationLanguageId());

        //Adds the translation for the name of the setup.
        GuidedExperience.AddTranslationForSetupObjectDescription(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::PTEStkAttributeAssistedSetup, Language.GetDefaultApplicationLanguageId(), SetupDescTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;
}