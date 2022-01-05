/// <summary>
/// PagePTEStkAttributeSearchEntry (ID 50109).
/// </summary>
page 50109 PTEStkAttributeItemSearch
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

                field(StockedAttributeSearchText; Rec.PTEStkAttributeSearchText)
                {
                    ToolTip = 'Attributes Search String';
                    ApplicationArea = All;
                }

                field(StockedAttributeSearchText2; Rec.PTEStkAttributeSearchText2)
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
    begin
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
            Item.SetFilter(PTEStkAttributeSearchText, FilterText);
            Item.SetFilter(PTEStkAttributeSearchText2, FilterText);
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
}
