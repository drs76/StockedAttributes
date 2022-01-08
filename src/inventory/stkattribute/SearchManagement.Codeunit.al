/// <summary>
/// Codeunit SearchManagement (ID 50104).
/// Search any table with OR on multiple fields for a search string.
/// </summary>
codeunit 50104 SearchManagement
{
    trigger OnRun()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ShipToAddress: Record "Ship-to Address";
        OrderAddress: Record "Order Address";
        Item: Record Item;
        RecRef: RecordRef;
        FieldIdList: List of [Integer];
        SearchTxt: Label 'London';
    begin
        //Search all code and text fields in customer
        PerformSearch(Customer, SearchTxt, FieldIdList, RecRef);
        RecRef.SetTable(Customer);
        Page.Run(0, Customer);

        //Search all code and text fields in vendor
        Clear(FieldIdList);
        PerformSearch(Vendor, SearchTxt, FieldIdList, RecRef);
        RecRef.SetTable(Vendor);
        Page.Run(0, Vendor);

        //Search all code and text fields in ship-to address
        Clear(FieldIdList);
        PerformSearch(ShipToAddress, SearchTxt, FieldIdList, RecRef);
        RecRef.SetTable(ShipToAddress);
        Page.Run(0, ShipToAddress);

        //Search all code and text fields in order address
        Clear(FieldIdList);
        PerformSearch(OrderAddress, SearchTxt, FieldIdList, RecRef);
        RecRef.SetTable(OrderAddress);
        Page.Run(0, OrderAddress);

        //Search on search description and description 2 fields only.
        Clear(FieldIdList);
        FieldIdList.Add(Item.FieldNo("Search Description"));
        PerformSearch(Item, SearchTxt, FieldIdList, RecRef);
        RecRef.SetTable(Item);
        Page.Run(0, Item);
    end;

    /// <summary>
    /// PerformSearch.
    /// </summary>
    /// <param name="RecordToSearch">Variant.</param>
    /// <param name="SearchFor">Text.</param>
    /// <param name="FieldIdList">VAR List of [Integer].</param>
    /// <param name="Result">VAR RecordRef.</param>
    procedure PerformSearch(RecordToSearch: Variant; SearchFor: Text; var FieldIdList: List of [Integer]; var Result: RecordRef)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        SearchFilter: Text;
        FldNo: Integer;
    begin
        Clear(Result);
        if (not RecordToSearch.IsRecord()) and (not RecordToSearch.IsRecordRef()) then
            exit;

        if RecordToSearch.IsRecord() then
            RecRef.GetTable(RecordToSearch)
        else
            RecRef := RecordToSearch;

        if FieldIdList.Count() = 0 then
            FieldIdList.AddRange(GetFieldIdsFilter(RecRef.Number()));

        RecRef.FilterGroup(-1);
        SearchFilter := PrepareFilterString(SearchFor);
        foreach FldNo in FieldIdList do
            if RecRef.FieldExist(FldNo) then begin
                FldRef := RecRef.Field(FldNo);
                FldRef.SetFilter(SearchFilter);
            end;

        MarkRecords(RecRef);

        Result := RecRef;
    end;

    /// <summary>
    /// MarkRecords.
    /// </summary>
    /// <param name="RecRef">VAR RecordRef.</param>
    local procedure MarkRecords(var RecRef: RecordRef)
    begin
        if RecRef.FindSet() then
            repeat
                RecRef.Mark(true);
            until RecRef.Next() = 0;
        RecRef.MarkedOnly(true);
    end;

    /// <summary>
    /// PrepareFilterString.
    /// </summary>
    /// <param name="SearchFor">Text.</param>
    /// <returns>Return value of type Text.</returns>
    local procedure PrepareFilterString(SearchFor: Text): Text
    var
        FilterTB: TextBuilder;
        WordList: List of [Text];
        Word: Text;
        SpaceTxt: Label ' ';
    begin
        WordList := SearchFor.Split(SpaceTxt);
        foreach Word in WordList do
            BuildFilter(FilterTB, Word);

        exit(FilterTB.ToText());
    end;

    /// <summary>
    /// GetFieldIdsFilter.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <returns>Return variable ReturnValue of type Text.</returns>
    local procedure GetFieldIdsFilter(TableNo: Integer) ReturnValue: List of [Integer]
    var
        Flds: Record Field;
        FldFilterTxt: Label '%1|%2';
    begin
        Flds.SetRange(TableNo, TableNo);
        Flds.SetFilter(Type, FldFilterTxt, Flds.Type::Text, Flds.Type::Code);
        Flds.SetRange(ObsoleteState, Flds.ObsoleteState::No);
        Flds.SetRange(Class, Flds.Class::Normal);
        if Flds.FindSet() then
            repeat
                ReturnValue.Add(Flds."No.");
            until Flds.Next() = 0;
    end;

    /// <summary>
    /// BuildFilter.
    /// </summary>
    /// <param name="FilterTb">VAR TextBuilder.</param>
    /// <param name="TextToAdd">Variant.</param>
    local procedure BuildFilter(var FilterTb: TextBuilder; TextToAdd: Variant)
    var
        OrLbl: Label '|';
        IdFilterLbl: Label '@*%1*';
    begin
        if FilterTB.Length() > 0 then
            FilterTB.Append(OrLbl);

        FilterTB.Append(StrSubstNo(IdFilterLbl, Format(TextToAdd)));
    end;
}