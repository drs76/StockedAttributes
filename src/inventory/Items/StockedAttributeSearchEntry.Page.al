/// <summary>
/// Page StockedAttributeSearchEntry (ID 50108).
/// </summary>
page 50108 StockedAttributeSearchEntry
{

    Caption = 'Stocked Attribute Search Entry';
    PageType = List;
    SourceTable = StockedAttributeDocEntryBuffer;
    SourceTableTemporary = true;
    UsageCategory = None;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(ItemDetails)
            {
                Caption = 'Item';
                field("Item No."; Item."No.")
                {
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the Item No. being configured';
                    Editable = false;
                    Style = Strong;
                    ApplicationArea = All;
                }

                field(Description; Item.Description)
                {
                    Caption = 'Item Description';
                    ToolTip = 'Specifies the Item main description';
                    Editable = false;
                    Style = Strong;
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }

            group(Search)
            {
                Caption = 'Search';

                field(SearchType; SearchType)
                {
                    Caption = 'Search Type';
                    OptionCaption = 'All Words,Any Word';
                    ToolTip = 'Specifies the Search Type to use';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        FilterForSearch();
                    end;
                }

                group(SearchTxt)
                {
                    ShowCaption = false;
                    field(SearchText; SearchText)
                    {
                        ShowCaption = false;
                        ToolTip = 'Enter search text to filter selections';
                        ApplicationArea = All;
                        ColumnSpan = 4;

                        trigger OnValidate()
                        begin
                            CurrPage.SaveRecord();
                            FilterForSearch();
                        end;
                    }
                }
            }

            repeater(General)
            {
                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the Variant Code';
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }

                field(StockedAttributeFullDescription; GetFullDescription())
                {
                    Caption = 'Description';
                    ToolTip = 'Full Item Variant description';
                    Editable = false;
                    ApplicationArea = All;
                }

                field(LocationCode; Rec.LocationCode)
                {
                    ToolTip = 'Specifies the Location Code';
                    ApplicationArea = All;
                }

                field(UnitofMeasureCode; Rec.UnitofMeasureCode)
                {
                    ToolTip = 'Specifies the Unit of Measure';
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the Quantity to Order';
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnOpenPage()
    var
        ItemToUse: Code[20];
        ItemErr: Label 'Item Required';
    begin
        Rec.FilterGroup(2);
        ItemToUse := CopyStr(Rec.GetFilter("Item No."), 1, MaxStrLen(ItemToUse));
        Rec.FilterGroup(0);
        if ItemToUse = '' then
            if Item."No." = '' then
                Error(ItemErr);

        SetItem(ItemToUse);
        BuildTableBuffer();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SaveChangesQst: Label 'Add selections to document';
    begin
        if Rec.Count() > 0 then
            ClosedWithSave := Confirm(SaveChangesQst, false);
    end;

    var
        Item: Record Item;
        SearchDict: Dictionary of [Integer, Text];
        SearchType: Option "All Words","Any Word";
        SearchText: Text;
        LocationDefault: Text;
        UoMDefault: Text;
        ClosedWithSave: Boolean;

    /// <summary>
    /// SetItem.
    /// </summary>
    /// <param name="ItemNoToUse">Code[20].</param>
    procedure SetItem(ItemNoToUse: Code[20])
    begin
        Item.Get(ItemNoToUse);
    end;

    /// <summary>
    /// GetRecords.
    /// </summary>
    /// <param name="TempStockedAttributeDocBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    procedure GetRecords(var TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary);
    begin
        Rec.ClearMarks();
        Rec.Reset();
        Rec.SetRange(Quantity, 0);
        Rec.DeleteAll();
        Rec.SetRange(Quantity);

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
    /// FilterForSearch.
    /// </summary>
    local procedure FilterForSearch()
    var
        BufferEntryNo: Integer;
        TextToSearch: Text;
        SearchList: List of [Text];
        SplitOnTxt: Label ' ';
        EmptySearchTxt: Label '';
    begin
        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        if SearchText <> EmptySearchTxt then begin
            SearchList := SearchText.Split(SplitOnTxt);

            foreach BufferEntryNo in SearchDict.Keys() do
                if SearchDict.Get(BufferEntryNo, TextToSearch) then
                    if SearchType = SearchType::"Any Word" then
                        CheckForAnyWord(SearchList, TextToSearch, BufferEntryNo)
                    else
                        CheckForAllWords(SearchList, TextToSearch, BufferEntryNo);

            Rec.MarkedOnly(true);
        end;
        UpdateShowFirst();
    end;

    /// <summary>
    /// CheckForWords.
    /// </summary>
    /// <param name="SearchList">VAR List of [Text].</param>
    /// <param name="TextToSearch">Text.</param>
    /// <param name="BufferEntryNo">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure CheckForAnyWord(var SearchList: List of [Text]; TextToSearch: Text; BufferEntryNo: Integer)
    var
        Word: Text;
    begin
        foreach Word in SearchList do
            if TextToSearch.ToUpper().Contains(Word.ToUpper()) then
                if Rec.Get(BufferEntryNo) then begin
                    Rec.Mark(true);
                    exit;
                end;
    end;

    /// <summary>
    /// CheckForAllWords.
    /// </summary>
    /// <param name="SearchList">VAR List of [Text].</param>
    /// <param name="TextToSearch">Text.</param>
    /// <param name="BufferEntryNo">Integer.</param>
    local procedure CheckForAllWords(var SearchList: List of [Text]; TextToSearch: Text; BufferEntryNo: Integer)
    var
        Word: Text;
    begin
        foreach Word in SearchList do
            if not TextToSearch.ToUpper().Contains(Word.ToUpper()) then
                exit;

        if Rec.Get(BufferEntryNo) then
            Rec.Mark(true);
    end;

    /// <summary>
    /// BuildTableBuffer.
    /// </summary>
    local procedure BuildTableBuffer()
    var
        ItemVariant: Record "Item Variant";
        EntryNo: Integer;
    begin
        Clear(SearchDict);
        ItemVariant.SetRange("Item No.", Item."No.");
        if ItemVariant.FindSet() then
            repeat
                InsertBufferRecord(ItemVariant, EntryNo);
            until ItemVariant.Next() = 0;

        UpdateShowFirst();
    end;

    /// <summary>
    /// InsertBufferRecord.
    /// </summary>
    /// <param name="ItemVariant">Record "Item Variant".</param>
    local procedure InsertBufferRecord(ItemVariant: Record "Item Variant"; var EntryNo: Integer)
    var
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
    begin
        EntryNo += 1;

        Rec.Init();
        Rec.EntryNo := EntryNo;
        Rec."Item No." := Item."No.";
        Rec."Variant Code" := ItemVariant.Code;
        Rec.LocationCode := CopyStr(LocationDefault, 1, MaxStrLen(Rec.LocationCode));
        Rec.UnitofMeasureCode := CopyStr(UoMDefault, 1, MaxStrLen(Rec.UnitofMeasureCode));
        Rec.AttributeSetId := ItemVariant."Attribute Set Id";
        Rec.Insert(true);

        SearchDict.Add(Rec.EntryNo, StockedAttributeMgmt.GetVariantFullDescription(Item, Rec.AttributeSetId))
    end;

    /// <summary>
    /// UpdateShowFirst.
    /// </summary>
    local procedure UpdateShowFirst()
    begin
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    /// <summary>
    /// GetFullDescription.
    /// </summary>
    /// <returns>Return variable ReturnValue of type Text.</returns>
    local procedure GetFullDescription() ReturnValue: Text
    begin
        if SearchDict.Get(Rec.EntryNo, ReturnValue) then
            exit;

        Clear(ReturnValue);
    end;
}
