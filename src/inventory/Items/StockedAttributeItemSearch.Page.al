/// <summary>
/// Page StockedAttributeSearchEntry (ID 50109).
/// </summary>
page 50109 StockedAttributeItemSearch
{
    AdditionalSearchTermsML = ENU = 'Item Search', ENG = 'Item Search';
    Caption = 'Stocked Attribute Item Search';
    PageType = List;
    SourceTable = Item;
    UsageCategory = Tasks;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            field(ItemCount; ItemCount)
            {
                Caption = 'Item Count';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Item Count';
            }

            group(Search)
            {
                Caption = 'Search';
                field("Item No."; ItemCategoryCode)
                {
                    Caption = 'Item Category';
                    ToolTip = 'Specifies the Item Category Code to filter on';
                    Style = Strong;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FilterForSearch();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemCategory: Record "Item Category";
                        ItemCategories: Page "Item Categories";
                    begin
                        ItemCategories.LookupMode(true);
                        if ItemCategory.Get(Text) then
                            ItemCategories.SetRecord(ItemCategory);
                        if ItemCategories.RunModal() <> Action::LookupOK then
                            exit(false);

                        ItemCategories.GetRecord(ItemCategory);
                        Text := ItemCategory.Code;
                        exit(true);
                    end;

                }

                field(ItemVendorNo; VendorNo)
                {
                    Caption = 'Vendor No.';
                    ToolTip = 'Specifies the Item Vendor to filter on';
                    Style = Strong;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FilterForSearch();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vendor: Record Vendor;
                        VendorList: Page "Vendor Lookup";
                    begin
                        VendorList.LookupMode(true);
                        if Vendor.Get(Text) then
                            VendorList.SetRecord(Vendor);
                        if VendorList.RunModal() <> Action::LookupOK then
                            exit(false);

                        VendorList.GetRecord(Vendor);
                        Text := Vendor."No.";
                        exit(true);
                    end;
                }

                field(VendorItem; VendorItemNo)
                {
                    Caption = 'Vendor Item No.';
                    ToolTip = 'Specifies the Item Vendor No. to filter on.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FilterForSearch();
                    end;
                }

                field(SearchType; SearchType)
                {
                    Caption = 'Search Type';
                    OptionCaption = 'All Words,Any Word';
                    ToolTip = 'Specifies the Search Type to use';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        FilterForSearch();
                    end;
                }

                field(Description; DescriptionSearch)
                {
                    Caption = 'Main Description Search';
                    ToolTip = 'Specifies the Item main description';
                    Style = Strong;
                    ApplicationArea = All;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        FilterForSearch();
                    end;
                }
            }

            repeater(General)
            {
                Editable = false;

                field(ItemNo; Rec."No.")
                {
                    ToolTip = 'Specifies the Item No.';
                    Editable = false;
                    ApplicationArea = All;
                }

                field(ItemDescription; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Item  description';
                    Editable = false;
                    ApplicationArea = All;
                }

                field(ItemDesc2; Rec."Description 2")
                {
                    ToolTip = 'Specifies the Location Code';
                    ApplicationArea = All;
                }

                field(ItemSearch; Rec."Search Description")
                {
                    ToolTip = 'Specifies the Unit of Measure';
                    ApplicationArea = All;
                }

                field(StockedAttributeSearchText; StockedAttributeSearchText)
                {
                    ToolTip = 'Attributes Search String';
                    ApplicationArea = All;
                }

                field(StockedAttributeSearchText2; StockedAttributeSearchText2)
                {
                    ToolTip = 'Attributes Search String 2';
                    ApplicationArea = All;
                }

                field(ItemVendor; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the Item Vendor No.';
                    ApplicationArea = All;
                }

                field(VendorItemNo; Rec."Vendor Item No.")
                {
                    ToolTip = 'Specifies the Vendor Item No.';
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnOpenPage()
    var
        LoadItemsQst: Label 'Load Items from file?';
        UpdateQst: Label 'Update Search Strings';
    begin
        if confirm(LoadItemsQst, false) then
            ImportTestItems();

        if Confirm(UpdateQst, false) then
            UpdateSearchStrings();

        ItemCount := Rec.Count();
        if Rec.FindFirst() then;
    end;

    var
        SearchType: Option "All Words","Any Word";
        DescriptionSearch: Text;
        VendorItemNo: Text[50];
        VendorNo: Code[20];
        ItemCategoryCode: Code[10];
        ItemCount: Integer;


    /// <summary>
    /// FilterForSearch.
    /// </summary>
    local procedure FilterForSearch()
    begin
        Rec.Reset();
        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        ApplyFilters();
        UpdateShowFirst();
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
    /// ApplyFilters.
    /// </summary>
    local procedure ApplyFilters()
    var
        Item: Record Item;
        FilterText: Text;
        EmptyTxt: Label '';
    begin
        if ItemCategoryCode + VendorNo + VendorItemNo + DescriptionSearch = EmptyTxt then
            exit;

        if ItemCategoryCode <> EmptyTxt then
            Item.SetRange("Item Category Code", ItemCategoryCode);

        if VendorNo <> EmptyTxt then
            Item.SetRange("Vendor No.", VendorNo);

        if VendorItemNo <> EmptyTxt then
            Item.SetRange("Vendor Item No.", VendorItemNo);

        if DescriptionSearch <> EmptyTxt then begin
            Item.FilterGroup(-1); //OR
            FilterText := BuildFilter();
            Item.SetFilter(Description, FilterText);
            Item.SetFilter("Description 2", FilterText);
            Item.SetFilter("Search Description", FilterText);
            Item.SetFilter(StockedAttributeSearchText, FilterText);
            Item.SetFilter(StockedAttributeSearchText2, FilterText);
        end;

        if Item.FindSet(false, false) then
            repeat
                Item.Mark(true);
            until Item.Next() = 0;

        Item.MarkedOnly(true);
        Rec.Copy(Item);
    end;

    /// <summary>
    /// BuildFilter.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    local procedure BuildFilter(): Text
    var
        SearchList: List of [Text];
        FilterTb: TextBuilder;
        Word: Text;
        SplitOnTxt: Label ' ';
        EmptyTxt: Label '';
    begin
        if DescriptionSearch = EmptyTxt then
            exit;

        SearchList := DescriptionSearch.Split(SplitOnTxt);
        foreach Word in SearchList do
            BuildFilterText(FilterTb, Word);

        exit(FilterTb.ToText());
    end;

    /// <summary>
    /// BuildFilterText.
    /// </summary>
    /// <param name="FilterTb">VAR TextBuilder.</param>
    /// <param name="Word">Text.</param>
    local procedure BuildFilterText(var FilterTb: TextBuilder; Word: Text)
    var
        FilterOrTxt: Label '%1%2';
        FilterWordTxt: Label '@*%1*';
        AndLbl: Label '&';
        OrLbl: Label '|';
    begin
        if FilterTb.Length() = 0 then
            FilterTb.Append(StrSubstNo(FilterWordTxt, Word))
        else
            if SearchType = SearchType::"Any Word" then
                FilterTb.Append(StrSubstNo(FilterOrTxt, OrLbl, StrSubstNo(FilterWordTxt, Word)))
            else
                FilterTb.Append(StrSubstNo(FilterOrTxt, AndLbl, StrSubstNo(FilterWordTxt, Word)));
    end;

    /// <summary>
    /// ImportTestItems.
    /// </summary>
    local procedure ImportTestItems()
    var
        TempCsvBufferTable: Record "CSV Buffer" temporary;
        TempCsvBufferTable2: Record "CSV Buffer" temporary;
        Window: Dialog;
        i: Integer;
        CommitCnt: Integer;
        ProcessT: Time;
        FilenameTxt: Label 'c:\run\my\items.csv';
        Filename2Txt: Label 'c:\run\my\colours.csv';
        ProgressTxt: Label 'Creating Item: #1##########################';
        CommaTxt: Label ',';
        EmptyTxt: Label '';
    begin
        Window.Open(ProgressTxt);
        TempCsvBufferTable.LoadData(FilenameTxt, CommaTxt, EmptyTxt);
        TempCsvBufferTable2.LoadData(Filename2Txt, CommaTxt, EmptyTxt);

        ProcessT := Time();

        for i := 1 to 1 do
            if TempCsvBufferTable.FindSet() then
                repeat
                    CommitCnt += 1;
                    if TempCsvBufferTable.Value <> EmptyTxt then begin
                        if Time() > (ProcessT + 1000) then begin
                            Window.Update(1, TempCsvBufferTable.Value);
                            ProcessT := Time();
                        end;
                        LoadNewItem(TempCsvBufferTable.Value, TempCsvBufferTable2, i);
                    end;
                    if CommitCnt > 500 then begin
                        Commit();
                        Clear(CommitCnt);
                    end;
                until TempCsvBufferTable.Next() = 0;

        Commit();
        Window.Close();
    end;

    /// <summary>
    /// LoadNewItem.
    /// </summary>
    /// <param name="ItemDescription">Text.</param>
    /// <param name="TempCsvBufferTable">Temporary VAR Record "CSV Buffer".</param>
    /// <param name="ItemCount">Integer.</param>
    local procedure LoadNewItem(ItemDescription: Text; var TempCsvBufferTable: Record "CSV Buffer" temporary; ItemCount: Integer)
    var
        Item: Record Item;
        ItemUoM: Record "Item Unit of Measure";
        ConfigTemplateHeader: Record "Config. Template Header";
        VariantMgmt: Codeunit StockedAttributeMgmt;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ItemRecRef: RecordRef;
        DescTxt: Label '%1 %2', Comment = '%1=Item Count, %2=Item Description';
        TemplateTxt: Label 'ITEM000001';
        UoMTxt: Label 'PCS';
        EmptyTxt: Label '';
    begin
        if ItemDescription = EmptyTxt then
            exit;

        ConfigTemplateHeader.Get(TemplateTxt);
        ItemRecRef.GetTable(Item);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
        ItemRecRef.SetTable(Item);

        if ItemCount in [1, 3] then begin
            Item.Description := CopyStr(StrSubStno(DescTxt, Format(ItemCount), ItemDescription), 1, MaxStrLen(Item.Description));
            Item."Description 2" := CopyStr(GetRandomColour(TempCsvBufferTable), 1, MaxStrLen(Item."Description 2"));
        end else begin
            Item."Description 2" := CopyStr(StrSubStno(DescTxt, Format(ItemCount), ItemDescription), 1, MaxStrLen(Item."Description 2"));
            Item.Description := CopyStr(GetRandomColour(TempCsvBufferTable), 1, MaxStrLen(Item.Description));
        end;
        Item."Search Description" := CopyStr(GetRandomColour(TempCsvBufferTable), 1, MaxStrLen(Item."Search Description"));
        ItemUom."Item No." := Item."No.";
        ItemUom.Code := UoMTxt;
        ItemUom.Insert();

        Item.Validate("Base Unit of Measure", UoMTxt);
        Item.Validate("Sales Unit of Measure", UoMTxt);
        Item."Vendor No." := GetRandomVendor();

        Item.StockedAttributeTemplateCode := GetRandDomTemplate();
        Item.Modify(true);

        if Item.StockedAttributeTemplateCode <> '' then
            VariantMgmt.CreateAllPossibleVariants(Item."No.", false);
    end;

    local procedure GetRandDomTemplate(): Code[20]
    var
        OptionsTemplate: Record StockedAttributeTemplate;
        StepCount: Integer;
    begin
        if OptionsTemplate.IsEmpty() then
            exit;

        StepCount := Random(OptionsTemplate.Count());

        OptionsTemplate.Find('-');
        if OptionsTemplate.Next(StepCount) = 0 then
            OptionsTemplate.FindFirst();

        exit(OptionsTemplate.Code);
    end;

    /// <summary>
    /// GetRandomVendor.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    local procedure GetRandomVendor(): Code[20]
    var
        Vendor: Record Vendor;
        StepCount: Integer;
    begin
        if Vendor.IsEmpty() then
            exit;

        StepCount := Random(Vendor.Count());

        Vendor.Find('-');
        if Vendor.Next(StepCount) = 0 then
            Vendor.FindFirst();

        exit(Vendor."No.");
    end;

    /// <summary>
    /// GetRandomColour.
    /// </summary>
    /// <param name="TempCsvBuffer">VAR Record "CSV Buffer".</param>
    /// <returns>Return value of type Text.</returns>
    local procedure GetRandomColour(var TempCsvBuffer: Record "CSV Buffer"): Text
    var
        StepCount: Integer;
    begin
        if TempCsvBuffer.IsEmpty() then
            exit;

        StepCount := Random(TempCsvBuffer.Count());

        TempCsvBuffer.Find('-');
        if TempCsvBuffer.Next(StepCount) = 0 then
            TempCsvBuffer.FindFirst();

        exit(TempCsvBuffer.Value);
    end;

    /// <summary>
    /// UpdateSearchStrings.
    /// </summary>
    local procedure UpdateSearchStrings()
    var
        Item: Record Item;
        StockAttribMgmt: Codeunit StockedAttributeMgmt;
    begin
        if not Item.FindSet() then
            exit;

        repeat
            StockAttribMgmt.CheckUpdateItemSearchTerms(Item, Item.StockedAttributeTemplateCode);
            Item.Find('=');
            if Item."Item Category Code" = '' then begin
                Item."Item Category Code" := GetRandomCategory();
                Item.Modify();
            end;
        until Item.Next() = 0;
    end;

    /// <summary>
    /// GetRandomCategory.
    /// </summary>
    /// <returns>Return value of type Code[10].</returns>
    local procedure GetRandomCategory(): Code[20]
    var
        ItemCategory: Record "Item Category";
        StepCount: Integer;
    begin
        if ItemCategory.IsEmpty() then
            exit;

        StepCount := Random(ItemCategory.Count());

        ItemCategory.Find('-');
        if ItemCategory.Next(StepCount) = 0 then
            ItemCategory.FindFirst();

        exit(ItemCategory.Code);
    end;
}
