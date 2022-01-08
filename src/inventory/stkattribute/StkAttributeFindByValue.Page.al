/// <summary>
/// PagePTEStkAttributeFindByValue (ID 50110).
/// </summary>
page 50110 PTEStkAttributeFindByValue
{

    Caption = 'Stocked Attribute Find By Value';
    PageType = List;
    SourceTable = "Item Variant";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Info)
                {
                    ShowCaption = false;
                    field(VariantCount; VariantCount)
                    {
                        ApplicationArea = All;
                        Caption = 'Variant Count';
                        ToolTip = 'Variant Count';
                        Editable = false;
                    }

                    field(SearchTextCtl; SearchText)
                    {
                        Caption = 'Search';
                        ToolTip = 'Enter text to find matching Items';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            SearchStockOptions();
                            CurrPage.Update(false);
                        end;
                    }

                }
            }
            repeater(variants)
            {
                Editable = false;
                Visible = ShowRepeater;
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Code';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Decription';
                }
            }
        }

        area(FactBoxes)
        {
            part(StockedAttributesFactBox; PTEStkAttributeFactbox)
            {
                ApplicationArea = All;
                SubPageLink = AttributeSetID = field(PTEStkAttributeSetId);
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowRepeater := SearchText <> '';
        VariantCount := Rec.Count();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ShowRepeater := SearchText <> '';
        CurrPage.Update(false);
    end;

    var
        SearchText: Text;
        VariantCount: Integer;

        [InDataSet]
        ShowRepeater: Boolean;


    /// <summary>
    /// SearchStockOptions.
    /// </summary>
    local procedure SearchStockOptions()
    var
        WordList: List of [Text];
        FoundEntryIds: List of [Integer];
        SearchTextTb: TextBuilder;
        SearchText2: Text;
        Word: Text;
        x: Integer;
        BadCharsTxt: Label '()|&*><"%';
        FilterTxt: Label '@*%1*';
        Filter2Txt: Label '|@*%1*';
        WhereLbl: Label '=';
        SpaceTxt: Label ' ';
        NowtMsg: Label 'Nothing Found';
        EmptyTxt: Label '';
    begin
        Rec.Reset();
        if SearchText = EmptyTxt then
            exit;

        // remove characters that might break filter.
        for x := 1 to StrLen(BadCharsTxt) do
            SearchText2 := DelChr(SearchText, WhereLbl, Format(BadCharsTxt) [x]);

        // split the words from the search string into a list of words
        WordList := SearchText2.Split(SpaceTxt);

        // iterate through the wordlist and build a filter to use for the query (Option Value).
        foreach Word in WordList do
            if SearchTextTb.Length() = 0 then
                SearchTextTb.Append(StrSubstNo(FilterTxt, Word))
            else
                SearchTextTb.Append(StrSubstNo(Filter2Txt, Word));

        // Append the list of Id's found by the query to the FoundEntryIds List.
        FoundEntryIds.AddRange(GetIdsFromQuery(SearchTextTb.ToText(), WordList.Count()));

        // Build a filter list of the Id's found by the query and apply to the record.
        Rec.SetFilter(PTEStkAttributeSetId, BuildSetIdFilter(FoundEntryIds));
        if Rec.GetFilter(PTEStkAttributeSetId) = '' then begin
            Message(NowtMsg);
            Clear(SearchText);
        end;

        if Rec.FindFirst() then;
    end;

    /// <summary>
    /// GetIdsFromQuery.
    /// </summary>
    /// <param name="FilterWord">Text.</param>
    /// <param name="MaxWords">Integer.</param>
    /// <returns>Return variable ReturnList of type List of [Integer].</returns>
    local procedure GetIdsFromQuery(FilterWord: Text; MaxWords: Integer) ReturnList: List of [Integer]
    var
        StockOptionsQry: Query PTEStkAttributeOptionQry;
    begin
        // filter on the option value field i.e. *green*|*Home Delivery*
        StockOptionsQry.SetFilter(Attribute_Value, FilterWord);
        // filter the Attribute Id Count to the Word Count, so that only Sets that have all matching entries are considered.
        StockOptionsQry.SetRange(AttributeIdCount, MaxWords);
        // Open the query 
        StockOptionsQry.Open();
        while StockOptionsQry.Read() do
            // read through the query and add the attribute set id's found to the return list
            ReturnList.Add(StockOptionsQry.Attribute_Set_ID);
    end;

    /// <summary>
    /// BuildSetIdFilter.
    /// </summary>
    /// <param name="IdsToMakeFilterWith">VAR List of [Integer].</param>
    /// <returns>Return value of type Text.</returns>
    local procedure BuildSetIdFilter(var IdsToMakeFilterWith: List of [Integer]): Text
    var
        FilterTb: TextBuilder;
        SetId: Integer;
        FilterTxt: Label '|%1';
    begin
        // Iterate through the list of id's found by the query
        foreach SetId in IdsToMakeFilterWith do
            // append the id to the Filter TextBuilder (a text builder is faster than concatenating i.e. txtVar + txtVar2)
            if FilterTb.Length() = 0 then
                FilterTb.Append(Format(SetId))
            else
                FilterTb.Append(StrSubstNo(FilterTxt, SetId));

        // return the filter string
        exit(FilterTb.ToText());
    end;
}
