/// <summary>
/// Page StockedAttributeQuickEntry (ID 50107).
/// </summary>
page 50107 StockedAttributeQuickEntry
{
    Caption = 'Variant Quick Entry';
    PageType = List;
    UsageCategory = None;
    SourceTable = StockedAttributeDocEntryBuffer;
    SourceTableTemporary = true;
    Editable = true;

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
            repeater(Configuration)
            {
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
                field(UnitofMeasureCode; Rec.UnitofMeasureCode)
                {
                    Caption = 'Unit of Measure';
                    ToolTip = 'Enter the unit of measure required';
                    ShowMandatory = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        currPage.SaveRecord();
                    end;
                }
                field(LocationCode; Rec.LocationCode)
                {
                    Caption = 'Location Code';
                    ToolTip = 'Enter the location required';
                    ShowMandatory = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        CurrPage.SaveRecord();
                    end;
                }

                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Required Quantity';
                    ToolTip = 'Enter the required quantity';
                    ShowMandatory = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Quantity <> xRec.Quantity then
                            FindVariant();

                        CurrPage.SaveRecord();
                    end;
                }

                field(EntryNo; Rec.EntryNo)
                {
                    Caption = 'Entry No.';
                    ToolTip = 'Entry No.';
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        Attributes: Dictionary of [Integer, Integer];
        Captions: array[20] of Text;
        Selections: array[20] of Text;
        SelectedValueIDs: array[20] of Integer;
        LocationDefault: Text;
        UoMDefault: Text;
        ClosedWithSave: Boolean;
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

    trigger OnOpenPage()
    begin
        InitPage();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SaveChangesQst: Label 'Add selections to document';
    begin
        if Rec.Count() > 0 then
            ClosedWithSave := Confirm(SaveChangesQst, false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.EntryNo := xRec.EntryNo + 1;
        Rec.TransferFields(xRec, false);
        Rec.Quantity := 0;
    end;

    trigger OnAfterGetRecord()
    begin
        GetRowSelections();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetRowSelections();
    end;

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
        Rec.EntryNo := 1;
        Rec."Item No." := Rec.GetRangeMin("Item No.");
        Rec.LocationCode := CopyStr(LocationDefault, 1, MaxStrLen(Rec.LocationCode));
        Rec.UnitofMeasureCode := CopyStr(UoMDefault, 1, MaxStrLen(Rec.UnitofMeasureCode));

        Item.Get(Rec."Item No.");
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

        Rec."Template Filter" := StockedAttributeTemplate."Template Set ID";
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
        UpdateSelections();
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

    /// <summary>
    /// UpdateSelections.
    /// </summary>
    local procedure UpdateSelections()
    var
        TxtBuilder: TextBuilder;
        x: Integer;
        CommaTxt: Label ',';
    begin
        Clear(Rec.PageSelections);
        for x := 1 to ArrayLen(SelectedValueIDs) do begin
            if txtBuilder.Length() > 0 then
                TxtBuilder.Append(CommaTxt);

            TxtBuilder.Append(Format(SelectedValueIDs[x]));
        end;
        Rec.PageSelections := COpyStr(TxtBuilder.ToText(), 1, MaxStrLen(Rec.PageSelections));
        CurrPage.SaveRecord();
    end;

    /// <summary>
    /// GetRowSelections.
    /// </summary>
    local procedure GetRowSelections()
    var
        ItemAttributeValue: Record "Item Attribute Value";
        SelectionsList: List of [Text];
        ListElement: Text;
        x: Integer;
        CommaTxt: Label ',';
    begin
        if StrLen(Rec.PageSelections) = 0 then
            exit;

        Clear(Selections);
        Clear(SelectedValueIDs);
        SelectionsList := Rec.PageSelections.Split(CommaTxt);
        for x := 1 to SelectionsList.Count() do
            if x <= ArrayLen(Selections) then
                if SelectionsList.Get(x, ListElement) then
                    if Evaluate(SelectedValueIDs[x], ListElement) then
                        if Attributes.ContainsKey(x) then
                            if ItemAttributeValue.Get(Attributes.Get(x), SelectedValueIDs[x]) then
                                Selections[x] := ItemAttributeValue.Value;
    end;
}