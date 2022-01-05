/// <summary>
/// Page StockedAttributeAssistedSetup (ID 50110).
/// </summary>
page 50111 StockedAttributeAssistedSetup
{
    Caption = 'Sci-Net Direct Debit Assisted Setup';
    PageType = NavigatePage;
    SourceTable = StockedAttributeSetup;
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(FirstStep)
            {
                Visible = CurrentPage = 1;
                group(Welcome)
                {
                    Caption = 'Welcome to Stocked Attributes Setup';
                    Visible = CurrentPage = 1;

                    group(Control18)
                    {
                        InstructionalText = 'This setup will allow you to specify the basic setup information for this application';
                        ShowCaption = false;
                    }
                }

                group(StartSetup)
                {
                    InstructionalText = 'Choose Next to start.';
                    ShowCaption = false;
                }
            }

            group(Step2)
            {
                Caption = '';
                Visible = CurrentPage = 2;
                InstructionalText = 'Please complete the following settings';

                group(Step2A)
                {
                    Caption = 'Select Default Entry Page Type.';
                    field(EntryPageType; Rec.EntryPageType)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        ToolTip = 'Default Order Entry Page for Stocked Attribute Items.';
                    }
                }

                group(Step2B)
                {
                    Caption = 'Enable Stocked Attributes';
                    field(Enabled; Rec.Enabled)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        ToolTip = 'Enable the Stocked Attribute Extension.';
                    }
                }
            }
            group(Step3)
            {
                ShowCaption = false;
                Visible = CurrentPage = 3;
                group(FinishSetup)
                {
                    InstructionalText = 'Finish setup';
                    group(Complete)
                    {
                        InstructionalText = 'To complete setup, choose Finish.';
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(BackAction)
            {
                ApplicationArea = All;
                Caption = '&Back';
                Enabled = (CurrentPage > 1) and (CurrentPage < 3);
                Image = PreviousRecord;
                InFooterBar = true;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ChangePage(-1, true);
                end;
            }
            action(NextAction)
            {
                ApplicationArea = All;
                Caption = '&Next';
                Enabled = (CurrentPage >= 1) and (CurrentPage < 3);
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ChangePage(1, false);
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = '&Finish';
                Enabled = CurrentPage = 3;
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                begin
                    Finish();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrentPage := 1;
        if not Rec.Get() then
            Rec.Insert(true);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if CloseAction = Action::OK then
            if GuidedExperience.AssistedSetupExistsAndIsNotComplete(ObjectType::Page, Page::StockedAttributeSetup) then
                if not Confirm(NAVNotSetUpQst, false) then
                    Error('');
    end;

    var
        StockedAttributeSetup: Record StockedAttributeSetup;
        CurrentPage: Integer;
        NAVNotSetUpQst: Label 'The Stocked Attribute setup has not been completed.\Are you sure you want to exit?';


    /// <summary>
    /// Finish.
    /// </summary>
    local procedure Finish()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        StockedAttributeSetup.Get();
        StockedAttributeSetup.Enabled := Rec.Enabled;
        StockedAttributeSetup.EntryPageType := Rec.EntryPageType;
        StockedAttributeSetup.Modify();

        GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::StockedAttributeSetup);
        GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::StockedAttributeAssistedSetup);
        CurrPage.Close();
    end;

    /// <summary>
    /// MovePage.
    /// </summary>
    /// <param name="Steps">Integer.</param>
    local procedure ChangePage(Steps: Integer; Update: Boolean)
    begin
        CurrentPage := CurrentPage + Steps;
        CurrPage.Update(Update);
    end;
}
