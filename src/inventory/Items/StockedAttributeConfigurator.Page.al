/// <summary>
/// Page StockedAttributeConfigurator (ID 50104).
/// </summary>
page 50104 StockedAttributeConfigurator
{
    Caption = 'Variant Configurator';
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = StockedAttributeDocEntryBuffer;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(ItemDetails)
            {
                Caption = 'Item';
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Item No. being configured';
                    Editable = false;
                    Style = Strong;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Item main description';
                    Editable = false;
                    Style = Strong;
                    ApplicationArea = All;
                }
            }
            group(Configuration)
            {
                Caption = 'Configuration';
                Visible = CurrentStep = 1;

                field(Selection1; Selections[1])
                {
                    CaptionClass = '3,' + Captions[1];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 1"));
                    ShowMandatory = true;
                    Visible = AttributeVisible1;
                    ToolTip = 'Attribute 1';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(1);
                    end;
                }

                field(Selection2; Selections[2])
                {
                    CaptionClass = '3,' + Captions[2];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 2"));
                    ShowMandatory = true;
                    Visible = AttributeVisible2;
                    ToolTip = 'Attribute 2';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(2);
                    end;
                }
                field(Selection3; Selections[3])
                {
                    CaptionClass = '3,' + Captions[3];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 3"));
                    ShowMandatory = true;
                    Visible = AttributeVisible3;
                    ToolTip = 'Attribute 3';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(3);
                    end;
                }
                field(Selection4; Selections[4])
                {
                    CaptionClass = '3,' + Captions[4];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 4"));
                    ShowMandatory = true;
                    Visible = AttributeVisible4;
                    ToolTip = 'Attribute 4';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(4);
                    end;
                }
                field(Selection5; Selections[5])
                {
                    CaptionClass = '3,' + Captions[5];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 5"));
                    ShowMandatory = true;
                    Visible = AttributeVisible5;
                    ToolTip = 'Attribute 5';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(5);
                    end;
                }
                field(Selection6; Selections[6])
                {
                    CaptionClass = '3,' + Captions[6];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 6"));
                    ShowMandatory = true;
                    Visible = AttributeVisible6;
                    ToolTip = 'Attribute 6';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(6);
                    end;
                }
                field(Selection7; Selections[7])
                {
                    CaptionClass = '3,' + Captions[7];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 7"));
                    ShowMandatory = true;
                    Visible = AttributeVisible7;
                    ToolTip = 'Attribute 7';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(7);
                    end;
                }
                field(Selection8; Selections[8])
                {
                    CaptionClass = '3,' + Captions[8];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 8"));
                    ShowMandatory = true;
                    Visible = AttributeVisible8;
                    ToolTip = 'Attribute 8';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(8);
                    end;
                }
                field(Selection9; Selections[9])
                {
                    CaptionClass = '3,' + Captions[9];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 9"));
                    ShowMandatory = true;
                    Visible = AttributeVisible9;
                    ToolTip = 'Attribute 9';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(9);
                    end;
                }
                field(Selection10; Selections[10])
                {
                    CaptionClass = '3,' + Captions[10];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 10"));
                    ShowMandatory = true;
                    Visible = AttributeVisible10;
                    ToolTip = 'Attribute 10';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(10);
                    end;
                }
                field(Selection11; Selections[11])
                {
                    CaptionClass = '3,' + Captions[11];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 11"));
                    ShowMandatory = true;
                    Visible = AttributeVisible11;
                    ToolTip = 'Attribute 11';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(11);
                    end;
                }
                field(Selection12; Selections[12])
                {
                    CaptionClass = '3,' + Captions[12];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 12"));
                    ShowMandatory = true;
                    Visible = AttributeVisible12;
                    ToolTip = 'Attribute 12';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(12);
                    end;
                }
                field(Selection13; Selections[13])
                {
                    CaptionClass = '3,' + Captions[13];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 13"));
                    ShowMandatory = true;
                    Visible = AttributeVisible13;
                    ToolTip = 'Attribute 13';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(13);
                    end;
                }
                field(Selection14; Selections[14])
                {
                    CaptionClass = '3,' + Captions[14];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 14"));
                    ShowMandatory = true;
                    Visible = AttributeVisible14;
                    ToolTip = 'Attribute 14';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(14);
                    end;
                }
                field(Selection15; Selections[15])
                {
                    CaptionClass = '3,' + Captions[15];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 15"));
                    ShowMandatory = true;
                    Visible = AttributeVisible15;
                    ToolTip = 'Attribute 15';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(15);
                    end;
                }
                field(Selection16; Selections[16])
                {
                    CaptionClass = '3,' + Captions[16];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 16"));
                    ShowMandatory = true;
                    Visible = AttributeVisible16;
                    ToolTip = 'Attribute 16';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(16);
                    end;
                }
                field(Selection17; Selections[17])
                {
                    CaptionClass = '3,' + Captions[17];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 17"));
                    ShowMandatory = true;
                    Visible = AttributeVisible17;
                    ToolTip = 'Attribute 17';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(17);
                    end;
                }
                field(Selection18; Selections[18])
                {
                    CaptionClass = '3,' + Captions[18];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 18"));
                    ShowMandatory = true;
                    Visible = AttributeVisible18;
                    ToolTip = 'Attribute 18';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(18);
                    end;
                }
                field(Selection19; Selections[19])
                {
                    CaptionClass = '3,' + Captions[19];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 19"));
                    ShowMandatory = true;
                    Visible = AttributeVisible19;
                    ToolTip = 'Attribute 19';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(19);
                    end;
                }
                field(Selection20; Selections[20])
                {
                    CaptionClass = '3,' + Captions[20];
                    TableRelation = StockedAttributeTemplateEntry.AttributeValueID where(TemplateID = field("Template Filter"), AttributeID = field("Attribute Filter 20"));
                    ShowMandatory = true;
                    Visible = AttributeVisible20;
                    ToolTip = 'Attribute 20';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        ValidateSelection(20);
                    end;
                }
            }
            group(EnterQuantity)
            {
                Caption = 'Required Quantity';
                Visible = CurrentStep = 2;
                field(UnitofMeasureCode; Rec.UnitofMeasureCode)
                {
                    Caption = 'Unit of Measure';
                    ToolTip = 'Enter the unit of measure required';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field(LocationCode; Rec.LocationCode)
                {
                    Caption = 'Location Code';
                    ToolTip = 'Enter the location required';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Required Quantity';
                    ToolTip = 'Enter the required quantity';
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }

            group(ConfirmSelections)
            {
                Caption = 'Confirm';
                Visible = CurrentStep = 3;

                repeater(Selections)
                {
                    field("Variant Code"; Rec."Variant Code")
                    {
                        Caption = 'Variant Code';
                        ToolTip = 'Variant code for selected configuration';
                        Editable = false;
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(UnitofMeasureCode2; Rec.UnitofMeasureCode)
                    {
                        Caption = 'Unit of Measure Code';
                        ToolTip = 'Unit of measure code for selected configuration';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field(Quantity2; Rec.Quantity)
                    {
                        Caption = 'Quantity';
                        ToolTip = 'Quantity required for selected configuration';
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Navigate)
            {
                action(Next)
                {
                    Caption = '&Next';
                    ToolTip = 'Next Configurator page';
                    Visible = NextVisible;
                    InFooterBar = true;
                    Image = NextRecord;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DoStep(1);
                    end;
                }

                action(Back)
                {
                    Caption = '&Back';
                    ToolTip = 'Previous Configurator page';
                    Visible = BackVisible;
                    InFooterBar = true;
                    Image = PreviousRecord;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        DoStep(-1);
                    end;
                }

                action(Add)
                {
                    Caption = '&Add';
                    ToolTip = 'Add configuration to selections';
                    Image = Save;
                    Visible = AddVisible;
                    InFooterBar = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        InitPage();
                        DoStep(1);
                    end;
                }
                action(Finish)
                {
                    Caption = '&Finish';
                    ToolTip = 'Close page, add selections to document';
                    Image = Post;
                    Visible = FinishVisible;
                    InFooterBar = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        ClosedWithSave := True;
                        CurrPage.Close();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitPage();
        DoStep(1); // page 1
    end;

    var
        Attributes: Dictionary of [Integer, Integer];
        Captions: array[20] of Text;
        Selections: array[20] of Text;
        SelectedValueIDs: array[20] of Integer;
        LocationDefault: Text;
        UoMDefault: Text;
        RecordCount: Integer;
        MaxSteps: Integer;
        CurrentStep: Integer;
        ClosedWithSave: Boolean;
        NextVisible: Boolean;
        BackVisible: Boolean;
        AddVisible: Boolean;
        FinishVisible: Boolean;
        AttributeVisible1: Boolean;
        AttributeVisible2: Boolean;
        AttributeVisible3: Boolean;
        AttributeVisible4: Boolean;
        AttributeVisible5: Boolean;
        AttributeVisible6: Boolean;
        AttributeVisible7: Boolean;
        AttributeVisible8: Boolean;
        AttributeVisible9: Boolean;
        AttributeVisible10: Boolean;
        AttributeVisible11: Boolean;
        AttributeVisible12: Boolean;
        AttributeVisible13: Boolean;
        AttributeVisible14: Boolean;
        AttributeVisible15: Boolean;
        AttributeVisible16: Boolean;
        AttributeVisible17: Boolean;
        AttributeVisible18: Boolean;
        AttributeVisible19: Boolean;
        AttributeVisible20: Boolean;

    /// <summary>
    /// SetLineDefaults.
    /// </summary>
    /// <param name="LocationDefaultIn">Text.</param>
    /// <param name="UoMDefaultIn">Text.</param>
    procedure SetLineDefaults(LocationDefaultIn: Text; UoMDefaultIn: Text)
    begin
        LocationDefault := LocationDefaultIn;
        UoMDefault := UoMDefaultIn;
    end;

    /// <summary>
    /// GetRecords.
    /// </summary>
    /// <param name="TempStockedAttributeDocBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    procedure GetRecords(var TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary);
    begin
        TempStockedAttributeDocBuffer.Copy(Rec, true);
    end;

    /// <summary>
    /// SaveSelections.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure SaveSelections(): Boolean;
    begin
        exit(ClosedWithSave);
    end;

    /// <summary>
    /// DoStep.
    /// </summary>
    /// <param name="StepCount">Integer.</param>
    local procedure DoStep(StepCount: Integer)
    begin
        if CurrentStep + StepCount > MaxSteps then
            exit;
        if CurrentStep + StepCount < 1 then
            exit;

        CurrentStep += StepCount;
        if CurrentStep = 3 then begin
            FindVariant();
            Modify();
        end;

        SetControls();
    end;

    /// <summary>
    /// SetControls.
    /// </summary>
    local procedure SetControls()
    begin
        NextVisible := CurrentStep < 3;
        BackVisible := CurrentStep > 1;
        AddVisible := CurrentStep = 3;
        FinishVisible := CurrentStep = 3;
    end;

    /// <summary>
    /// InitPage.
    /// </summary>
    local procedure InitPage()
    var
        Item: Record Item;
        StockedAttributeTemplate: Record StockedAttributeTemplate;
        TempAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary;
        StockedAttributeEntrySetup: Codeunit StockedAttributeEntryPageMgmt;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        AttributeCount: Integer;
    begin
        MaxSteps := 3; // Maximum navigation steps
        Clear(CurrentStep);

        Rec.Init();
        RecordCount += 1;
        EntryNo := RecordCount;
        "Item No." := GetRangeMin("Item No.");
        LocationCode := CopyStr(LocationDefault, 1, MaxStrLen(LocationCode));
        UnitofMeasureCode := CopyStr(UoMDefault, 1, MaxStrLen(UnitofMeasureCode));

        Item.Get("Item No.");
        Item.TestField(StockedAttributeTemplateCode);
        StockedAttributeTemplate.Get(Item.StockedAttributeTemplateCode);

        StockedAttributeMgmt.GetAttributeTemplateSet(TempAttributeTemplateEntry, StockedAttributeTemplate."Template Set ID");

        StockedAttributeEntrySetup.SetStockedAttributeDocEntryBuffer(Rec);
        StockedAttributeEntrySetup.SetTempAttributeEntry(TempAttributeTemplateEntry);
        StockedAttributeEntrySetup.SetupPage();

        StockedAttributeEntrySetup.GetAttributeCount(AttributeCount);
        StockedAttributeEntrySetup.GetAttributes(Attributes);
        StockedAttributeEntrySetup.GetCaptions(Captions);
        StockedAttributeEntrySetup.GetStockedAttributeDocEntryBuffer(Rec);

        SetFieldsVisible(AttributeCount);

        "Template Filter" := StockedAttributeTemplate."Template Set ID";
        Rec.Insert();
    end;

    /// <summary>
    /// SetFieldsVisible.
    /// </summary>
    /// <param name="AttributeCount">Integer.</param>
    local procedure SetFieldsVisible(AttributeCount: Integer)
    var
        x: Integer;
    begin
        for x := 1 to AttributeCount do
            case x of
                1:
                    AttributeVisible1 := true;
                2:
                    AttributeVisible2 := true;
                3:
                    AttributeVisible3 := true;
                4:
                    AttributeVisible4 := true;
                5:
                    AttributeVisible5 := true;
                6:
                    AttributeVisible6 := true;
                7:
                    AttributeVisible7 := true;
                8:
                    AttributeVisible8 := true;
                9:
                    AttributeVisible9 := true;
                10:
                    AttributeVisible10 := true;
                11:
                    AttributeVisible11 := true;
                12:
                    AttributeVisible12 := true;
                13:
                    AttributeVisible13 := true;
                14:
                    AttributeVisible14 := true;
                15:
                    AttributeVisible15 := true;
                16:
                    AttributeVisible16 := true;
                17:
                    AttributeVisible17 := true;
                18:
                    AttributeVisible18 := true;
                19:
                    AttributeVisible19 := true;
                20:
                    AttributeVisible20 := true;
            end;
    end;

    /// <summary>
    /// ValidateSelection.
    /// </summary>
    /// <param name="ColumnNo">Integer.</param>
    local procedure ValidateSelection(ColumnNo: Integer)
    var
        StockedAttributeEntrySetup: Codeunit StockedAttributeEntryPageMgmt;
    begin
        StockedAttributeEntrySetup.ValidateEntry(ColumnNo, Attributes, Selections, SelectedValueIDs);
        currPage.SaveRecord();
    end;

    /// <summary>
    /// FindVariant.
    /// </summary>
    local procedure FindVariant()
    var
        StockedAttributeEntrySetup: Codeunit StockedAttributeEntryPageMgmt;
    begin
        StockedAttributeEntrySetup.EntryPageFindVariant(Rec, Attributes, SelectedValueIDs);
    end;
}