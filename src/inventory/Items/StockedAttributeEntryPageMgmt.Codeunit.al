/// <summary>
/// Codeunit StockedAttributeEntryPageMgmt (ID 50103).
/// </summary>
codeunit 50103 StockedAttributeEntryPageMgmt
{
    var
        TempStockedAttributeDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary;
        TempAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary;
        Attributes: Dictionary of [Integer, Integer];
        Captions: array[20] of Text;
        AttributeCount: Integer;


    /// <summary>
    /// SetupPage.
    /// </summary>
    procedure SetupPage()
    var
        CurrentID: Integer;
    begin
        if not TempAttributeTemplateEntry.FindSet() then
            exit;

        Clear(CurrentID);
        repeat
            if TempAttributeTemplateEntry.AttributeID <> CurrentID then
                if not Attributes.Values().Contains(TempAttributeTemplateEntry.AttributeID) then
                    SetupPageParts(TempAttributeTemplateEntry);

            CurrentID := TempAttributeTemplateEntry.AttributeID;
        until (TempAttributeTemplateEntry.Next() = 0) or (AttributeCount = ArrayLen(Captions));

        if TempAttributeTemplateEntry.AttributeID <> CurrentID then
            if not Attributes.Values().Contains(TempAttributeTemplateEntry.AttributeID) then
                SetupPageParts(TempAttributeTemplateEntry);
    end;

    /// <summary>
    /// SetupPageParts.
    /// </summary>
    /// <param name="TempTemplateEntry">Temporary Record StockedAttributeTemplateEntry.</param>
    local procedure SetupPageParts(TempTemplateEntry: Record StockedAttributeTemplateEntry temporary)
    begin
        TempTemplateEntry.CalcFields("Attribute Code");

        AttributeCount += 1;

        Attributes.Add(AttributeCount, TempTemplateEntry.AttributeID); // Attribute ID's in use
        SetFlowFilters(AttributeCount, TempTemplateEntry.AttributeID);

        Captions[AttributeCount] := TempTemplateEntry."Attribute Code"; // Captions for fields.

        SetFlowFilters(AttributeCount, TempTemplateEntry.AttributeID);
    end;

    /// <summary>
    /// SetFlowFilters.
    /// </summary>
    /// <param name="FieldToSet">Integer.</param>
    /// <param name="IDToSet">Integer.</param>
    local procedure SetFlowFilters(FieldToSet: Integer; IDToSet: Integer)
    begin
        case FieldToSet of
            1:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 1" := IDToSet;
            2:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 2" := IDToSet;
            3:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 3" := IDToSet;
            4:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 4" := IDToSet;
            5:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 5" := IDToSet;
            6:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 6" := IDToSet;
            7:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 7" := IDToSet;
            8:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 8" := IDToSet;
            9:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 9" := IDToSet;
            10:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 10" := IDToSet;
            11:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 11" := IDToSet;
            12:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 12" := IDToSet;
            13:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 13" := IDToSet;
            14:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 14" := IDToSet;
            15:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 15" := IDToSet;
            16:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 16" := IDToSet;
            17:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 17" := IDToSet;
            18:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 18" := IDToSet;
            19:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 19" := IDToSet;
            20:
                TempStockedAttributeDocEntryBuffer."Attribute Filter 20" := IDToSet;
        end;
    end;

    /// <summary>
    /// GetCaptions.
    /// </summary>
    /// <param name="NewCaptions">VAR array[20] of Text.</param>
    procedure GetCaptions(var NewCaptions: array[20] of Text)
    var
        x: Integer;
    begin
        for x := 1 to ArrayLen(NewCaptions) do
            NewCaptions[x] := Captions[x];
    end;

    /// <summary>
    /// GetAttributes.
    /// </summary>
    /// <param name="NewAttributes">VAR Dictionary of [Integer, Integer].</param>
    procedure GetAttributes(var NewAttributes: Dictionary of [Integer, Integer])
    begin
        NewAttributes := Attributes;
    end;

    /// <summary>
    /// GetAttributeCount.
    /// </summary>
    /// <param name="NewAttributeCount">VAR Integer.</param>
    procedure GetAttributeCount(var NewAttributeCount: Integer)
    begin
        NewAttributeCount := AttributeCount;
    end;

    /// <summary>
    /// SetTempAttributeEntry.
    /// </summary>
    /// <param name="NewTempAttributeTemplateEntry">Temporary VAR Record StockedAttributeTemplateEntry.</param>
    procedure SetTempAttributeEntry(var NewTempAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary)
    begin
        TempAttributeTemplateEntry.Copy(NewTempAttributeTemplateEntry, true);
    end;

    /// <summary>
    /// GetStockedAttributeDocEntryBuffer.
    /// </summary>
    /// <param name="NewStockedAttributeDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    procedure SetStockedAttributeDocEntryBuffer(var NewStockedAttributeDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary)
    begin
        TempStockedAttributeDocEntryBuffer.Copy(NewStockedAttributeDocEntryBuffer, true);
    end;

    /// <summary>
    /// GetStockedAttributeDocEntryBuffer.
    /// </summary>
    /// <param name="NewStockedAttributeDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    procedure GetStockedAttributeDocEntryBuffer(var NewStockedAttributeDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary)
    begin
        NewStockedAttributeDocEntryBuffer.Copy(TempStockedAttributeDocEntryBuffer, true);
    end;

    /// <summary>
    /// ValidateEntry.
    /// </summary>
    /// <param name="ColumnNo">Integer.</param>
    /// <param name="Attributes">VAR Dictionary of [Integer, Integer].</param>
    /// <param name="Selections">VAR array[20] of Text.</param>
    /// <param name="ValueIDs">VAR array[20] of Integer.</param>
    procedure ValidateEntry(ColumnNo: Integer; var Attributes: Dictionary of [Integer, Integer]; var Selections: array[20] of Text; var ValueIDs: array[20] of Integer)
    var
        ItemAttributeValue: Record "Item Attribute Value";
        SelectedAttributeID: Integer;
        SelectedValueID: Integer;
        EmptyTxt: Label '';
    begin
        SelectedAttributeID := Attributes.Get(ColumnNo);
        if not Evaluate(SelectedValueID, Selections[ColumnNo]) then begin
            ItemAttributeValue.SetRange("Attribute ID", SelectedAttributeID);
            ItemAttributeValue.SetRange(Value, Selections[ColumnNo]);
            if ItemAttributeValue.FindFirst() then
                SelectedValueID := ItemAttributeValue.ID;
        end;

        if not ItemAttributeValue.Get(SelectedAttributeID, SelectedValueID) then begin
            ValueIDs[ColumnNo] := 0;
            Selections[ColumnNo] := EmptyTxt;
            exit;
        end;

        // store actual id in array and show the value in field control
        ValueIDs[ColumnNo] := SelectedValueID;
        Selections[ColumnNo] := ItemAttributeValue.Value;
    end;

    /// <summary>
    /// EntryPageFindVariant.
    /// </summary>
    /// <param name="TempDocBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    /// <param name="Attributes">Dictionary of [Integer, Integer].</param>
    /// <param name="ValueIDs">VAR array[20] of Integer.</param>
    procedure EntryPageFindVariant(var TempDocBuffer: Record StockedAttributeDocEntryBuffer temporary; Attributes: Dictionary of [Integer, Integer]; var ValueIDs: array[20] of Integer)
    var
        TempSetEntry: Record StockedAttributeSetEntry temporary;
        ItemVariant: Record "Item Variant";
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        FoundSetID: Integer;
        x: Integer;
        CannotFindErr: Label 'Cannot locate a matching configuration';
        EmptyTxt: Label '';
    begin
        for x := 1 to ArrayLen(ValueIDs) do
            if ValueIDs[x] > 0 then begin
                TempSetEntry.Init();
                TempSetEntry.AttributeID := Attributes.Get(x);
                TempSetEntry.AttributeValueID := ValueIDs[x];
                TempSetEntry.Insert();
            end;

        Clear(TempDocBuffer."Variant Code");
        FoundSetID := StockedAttributeMgmt.GetAttributeSetID(TempSetEntry);
        if FoundSetID > 0 then begin
            ItemVariant.SetRange("Item No.", TempDocBuffer."Item No.");
            ItemVariant.SetRange("Attribute Set Id", FoundSetID);
            if ItemVariant.FindFirst() then begin
                TempDocBuffer."Variant Code" := ItemVariant.Code;
                TempDocBuffer.AttributeSetId := ItemVariant."Attribute Set Id";
            end;
        end;

        if TempDocBuffer."Variant Code" = EmptyTxt then
            Error(CannotFindErr);
    end;
}
