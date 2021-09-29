/// <summary>
/// Codeunit StockedAttributeDocEntryMgmt (ID 50101).
/// </summary>
codeunit 50101 StockedAttributeDocEntryMgmt
{
    // Methods used for the Stocked Attribute Configurator Entry page.
    var
        DocumentFields: array[6] of Text;
        JournalFields: array[6] of Text;
        DocumentKeys: array[2] of Text;
        JournalKeys: array[2] of Text;
        ItemNoFieldTxt: Label 'No.|Item No.';
        LineNoFieldTxt: Label 'Line No.';
        UoMFieldTxt: Label 'Unit of Measure Code';
        LocationCodeFieldTxt: Label 'Location Code';

    /// <summary>
    /// LaunchStockedAttributeConfigurator.
    /// </summary>
    /// <param name="SourceRecordRef">RecordRef.</param>
    procedure LaunchStockedAttributeConfigurator(SourceRecordRef: RecordRef)
    var
        TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary;
        Parameters: JsonObject;
    begin
        InitFields(); // setup field arrays required.

        PrepareConfigurator(SourceRecordRef, Parameters);

        if GetPageIdToRun(Parameters) then
            if RunAttributeVariantEntry(Parameters, TempStockedAttributeDocBuffer) then
                AddSelectionsToDocument(SourceRecordRef, Parameters, TempStockedAttributeDocBuffer);
    end;

    /// <summary>
    /// InitFields.
    /// </summary>
    local procedure InitFields()
    var
        DocumentTypeTxt: Label 'Document Type';
        DocumentNoTxt: Label 'Document No.';
        JournalTmpltNameTxt: Label 'Journal Template Name';
        JournalBatchNameTxt: Label 'Journal Batch Name';
    begin
        DocumentFields[1] := DocumentTypeTxt;
        DocumentFields[2] := DocumentNoTxt;
        DocumentFields[3] := LineNoFieldTxt;
        DocumentFields[4] := ItemNoFieldTxt;
        DocumentFields[5] := UoMFieldTxt;
        DocumentFields[6] := LocationCodeFieldTxt;

        JournalFields[1] := JournalTmpltNameTxt;
        JournalFields[2] := JournalBatchNameTxt;
        JournalFields[3] := LineNoFieldTxt;
        JournalFields[4] := ItemNoFieldTxt;
        JournalFields[5] := UoMFieldTxt;
        JournalFields[6] := LocationCodeFieldTxt;

        DocumentKeys[1] := DocumentTypeTxt;
        DocumentKeys[2] := DocumentNoTxt;

        JournalKeys[1] := JournalTmpltNameTxt;
        JournalKeys[2] := JournalBatchNameTxt;
    end;

    /// <summary>
    /// PrepareConfigurator.
    /// </summary>
    /// <param name="SourceRecordRef">RecordRef.</param>
    /// <param name="Parameters">VAR JsonObject.</param>
    local procedure PrepareConfigurator(SourceRecordRef: RecordRef; var Parameters: JsonObject);
    var
        SourceFieldRef: FieldRef;
        FieldName: Text;
        FieldNumber: Integer;
        OptionValue: Integer;
        x: Integer;
    begin
        for x := 1 to ArrayLen(DocumentFields) do begin
            if SourceRecordRef.Number() = Database::"Item Journal Line" then
                FieldName := JournalFields[x]
            else
                FieldName := DocumentFields[x];

            FieldNumber := GetFieldNumber(SourceRecordRef.Number(), FieldName);
            if FieldNumber <> 0 then begin
                SourceFieldRef := SourceRecordRef.Field(FieldNumber);
                if SourceFieldRef.Type() in [SourceFieldRef.Type() ::Option] then begin
                    OptionValue := SourceFieldRef.Value();
                    Parameters.Add(FieldName, OptionValue);
                end else
                    Parameters.Add(FieldName, Format(SourceFieldRef.Value()));
            end;
        end;
    end;

    /// <summary>
    /// GetPageIdToRun.
    /// </summary>
    /// <param name="Parameters">VAR JsonObject.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure GetPageIdToRun(var Parameters: JsonObject): Boolean;
    var
        Item: Record Item;
        StockedAttributeTemplate: Record StockedAttributeTemplate;
        StockedAttributeSetup: Record StockedAttributeSetup;
        EntryPageType: Enum StockedAttributeEntryPageType;
        JToken: JsonToken;
        PageId: Integer;
        PageLbl: Label 'Page';
        MissingParamErr: Label 'Mising Item Parameter';
    begin
        if not Parameters.Get(ItemNoFieldTxt, JToken) then
            Error(MissingParamErr);

        Item.Get(JToken.AsValue().AsText());

        if Item.StockedAttributeEntryPageType = EntryPageType::Default then begin
            StockedAttributeTemplate.Get(Item.StockedAttributeTemplateCode);
            if StockedAttributeTemplate.EntryPageType = EntryPageType::Default then begin
                StockedAttributeSetup.Get();
                PageId := StockedAttributeSetup.EntryPageType.AsInteger();
            end else
                PageId := StockedAttributeTemplate.EntryPageType.AsInteger();
        end else
            if Item.StockedAttributeEntryPageType <> EntryPageType::None then
                PageId := Item.StockedAttributeEntryPageType.AsInteger();

        case PageId of
            EntryPageType::Configurator.AsInteger():
                PageId := Page::StockedAttributeConfigurator;
            EntryPageType::"Quick Entry".AsInteger():
                PageId := Page::StockedAttributeQuickEntry;
        end;

        if PageId <> 0 then
            Parameters.Add(PageLbl, PageId); // page to use.    

        exit(PageId <> 0);
    end;

    /// <summary>
    /// RunAttributeVariantEntry.
    /// </summary>
    /// <param name="Parameters">JsonObject.</param>
    /// <param name="TempDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure RunAttributeVariantEntry(Parameters: JsonObject; var TempDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary): Boolean;
    var
        ItemNo: Text;
        LocationCodeParam: Text;
        UoCodeParam: Text;
        PageNo: Integer;
    begin
        SetupPageParams(Parameters, ItemNo, LocationCodeParam, UoCodeParam, PageNo);
        if ItemNo = '' then
            exit;

        Commit();

        TempDocEntryBuffer.FilterGroup(2);
        TempDocEntryBuffer.SetRange("Item No.", ItemNo);
        TempDocEntryBuffer.FilterGroup(0);

        exit(RunEntryPage(PageNo, TempDocEntryBuffer, LocationCodeParam, UoCodeParam));
    end;

    /// <summary>
    /// SetupPageParams.
    /// </summary>
    /// <param name="Parameters">JsonObject.</param>
    /// <param name="ItemNo">VAR Text.</param>
    /// <param name="LocationCode">VAR Text.</param>
    /// <param name="UoM">VAR Text.</param>
    /// <param name="PageNo">VAR Integer.</param>
    local procedure SetupPageParams(Parameters: JsonObject; var ItemNo: Text; var LocationCode: Text; var UoM: Text; var PageNo: Integer)
    var
        JToken: JsonToken;
        PageLbl: Label 'Page';
    begin
        if Parameters.Get(PageLbl, JToken) then
            PageNo := JToken.AsValue().AsInteger();

        if Parameters.Get(ItemNoFieldTxt, JToken) then
            ItemNo := JToken.AsValue().AsText();

        if Parameters.Get(LocationCodeFieldTxt, JToken) then
            LocationCode := JToken.AsValue().AsText();

        if Parameters.Get(UoMFieldTxt, JToken) then
            UoM := JToken.AsValue().AsText();
    end;

    /// <summary>
    /// RunEntryPage.
    /// </summary>
    /// <param name="PageNo">Integer.</param>
    /// <param name="TempDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    /// <param name="Location">Text.</param>
    /// <param name="UOM">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure RunEntryPage(PageNo: Integer; var TempDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary; Location: Text; UOM: Text): Boolean
    begin
        if PageNo = Page::StockedAttributeConfigurator then
            exit(RunConfigurator(TempDocEntryBuffer, Location, UOM));

        if PageNo = Page::StockedAttributeQuickEntry then
            exit(RunQuickEntry(TempDocEntryBuffer, Location, UOM));
    end;

    /// <summary>
    /// RunConfigurator.
    /// </summary>
    /// <param name="TempDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    /// <param name="Location">Text.</param>
    /// <param name="UOM">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure RunConfigurator(var TempDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary; Location: Text; UOM: Text): Boolean
    var
        VariantConfigurator: Page StockedAttributeConfigurator;
    begin
        VariantConfigurator.SetTableView(TempDocEntryBuffer);
        VariantConfigurator.SetLineDefaults(Location, UOM);
        VariantConfigurator.RunModal();
        if not VariantConfigurator.SaveSelections() then
            exit(false);

        VariantConfigurator.GetRecords(TempDocEntryBuffer);
        exit(true);
    end;

    /// <summary>
    /// RunQuickEntry.
    /// </summary>
    /// <param name="TempDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    /// <param name="Location">Text.</param>
    /// <param name="UOM">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure RunQuickEntry(var TempDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary; Location: Text; UOM: Text): Boolean;
    var
        VariantQuickEntry: Page StockedAttributeQuickEntry;
    begin
        VariantQuickEntry.SetTableView(TempDocEntryBuffer);
        VariantQuickEntry.SetLineDefaults(Location, UOM);
        VariantQuickEntry.RunModal();

        if not VariantQuickEntry.SaveSelections() then
            exit(false);

        VariantQuickEntry.GetRecords(TempDocEntryBuffer);
        exit(true);
    end;

    /// <summary>
    /// AddSelectionsToDocument.
    /// </summary>
    /// <param name="SourceRecordRef">RecordRef.</param>
    /// <param name="Parameters">JsonObject.</param>
    /// <param name="TempDocEntryBuffer">Temporary VAR Record StockedAttributeDocEntryBuffer.</param>
    local procedure AddSelectionsToDocument(SourceRecordRef: RecordRef; Parameters: JsonObject; var TempDocEntryBuffer: Record StockedAttributeDocEntryBuffer temporary)
    var
        Item: Record Item;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        NewLineRecordRef: RecordRef;
        ItemToken: JsonToken;
        VariantFieldNo: Integer;
        QuantityFieldNo: Integer;
        UoMFieldNo: Integer;
        LocationFieldNo: Integer;
        DescriptionFieldNo: Integer;
        VariantCodeFieldNameTxt: Label 'Variant Code';
        QuantityFieldNameTxt: Label 'Quantity';
        UoMFieldNameTxt: Label 'Unit of Measure Code';
        DescriptionNameTxt: Label 'Description';
    begin
        if Parameters.Get(ItemNoFieldTxt, ItemToken) then
            Item.Get(ItemToken.AsValue().AsText());

        if TempDocEntryBuffer.FindSet() then begin
            SourceRecordRef.Find('=');

            VariantFieldNo := GetFieldNumber(SourceRecordRef.Number(), VariantCodeFieldNameTxt);
            QuantityFieldNo := GetFieldNumber(SourceRecordRef.Number(), QuantityFieldNameTxt);
            UoMFieldNo := GetFieldNumber(SourceRecordRef.Number(), UoMFieldNameTxt);
            LocationFieldNo := GetFieldNumber(SourceRecordRef.Number(), LocationCodeFieldTxt);
            DescriptionFieldNo := GetFieldNumber(SourceRecordRef.Number(), DescriptionNameTxt);

            // Update fields on source line
            UpdateRecordRef(SourceRecordRef, VariantFieldNo, TempDocEntryBuffer."Variant Code");
            UpdateRecordRef(SourceRecordRef, QuantityFieldNo, TempDocEntryBuffer.Quantity);
            UpdateRecordRef(SourceRecordRef, UoMFieldNo, TempDocEntryBuffer.UnitofMeasureCode);
            UpdateRecordRef(SourceRecordRef, LocationFieldNo, TempDocEntryBuffer.LocationCode);
            UpdateRecordRef(SourceRecordRef, DescriptionFieldNo, StockedAttributeMgmt.GetVariantFullDescription(Item, TempDocEntryBuffer.AttributeSetId));
            SourceRecordRef.Modify();

            // Add any additional selections to the document.
            if TempDocEntryBuffer.Next() <> 0 then
                repeat
                    // Add new line
                    AddLine(NewLineRecordRef, SourceRecordRef, Parameters);

                    // Update field on new line
                    UpdateRecordRef(NewLineRecordRef, VariantFieldNo, TempDocEntryBuffer."Variant Code");
                    UpdateRecordRef(NewLineRecordRef, QuantityFieldNo, TempDocEntryBuffer.Quantity);
                    UpdateRecordRef(NewLineRecordRef, UoMFieldNo, TempDocEntryBuffer.UnitofMeasureCode);
                    UpdateRecordRef(NewLineRecordRef, LocationFieldNo, TempDocEntryBuffer.LocationCode);
                    UpdateRecordRef(SourceRecordRef, DescriptionFieldNo, StockedAttributeMgmt.GetVariantFullDescription(Item, TempDocEntryBuffer.AttributeSetId));
                    NewLineRecordRef.Modify(true);
                until TempDocEntryBuffer.Next() = 0;
        end;
    end;

    /// <summary>
    /// UpdateRecordRef.
    /// </summary>
    /// <param name="RecordRefToUpdate">VAR RecordRef.</param>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="FieldValue">Variant.</param>
    local procedure UpdateRecordRef(var RecordRefToUpdate: RecordRef; FieldNumber: Integer; FieldValue: Variant)
    var
        FieldRefToSet: FieldRef;
        DescriptionNameTxt: Label 'Description';
    begin
        FieldRefToSet := RecordRefToUpdate.Field(FieldNumber);

        if FieldRefToSet.Name = DescriptionNameTxt then begin
            if StrLen(Format(FieldValue)) = 0 then
                exit;
            FieldRefToSet.Value := CopyStr(Format(FieldValue), 1, FieldRefToSet.Length);
        end else
            FieldRefToSet.Validate(FieldValue);
    end;

    /// <summary>
    /// AddLine.
    /// </summary>
    /// <param name="NewLineRecoredRef">VAR RecordRef.</param>
    /// <param name="SourceRecordRef">RecordRef.</param>
    /// <param name="Parameters">JsonObject.</param>
    local procedure AddLine(var NewLineRecoredRef: RecordRef; SourceRecordRef: RecordRef; Parameters: JsonObject)
    var
        FldRef: FieldRef;
        FilterToken: JsonToken;
        KeyNames: array[2] of Text;
        NextLineNo: Integer;
    begin
        NewLineRecoredRef := SourceRecordRef;

        if NewLineRecoredRef.Number() = Database::"Item Journal Line" then begin
            KeyNames[1] := JournalKeys[1];
            KeyNames[2] := JournalKeys[2];
        end else begin
            KeyNames[1] := DocumentKeys[1];
            KeyNames[2] := DocumentKeys[2];
        end;

        if Parameters.Get(KeyNames[1], FilterToken) then
            FilterOnKey(NewLineRecoredRef, KeyNames[1], FilterToken.AsValue().AsText());

        if Parameters.Get(KeyNames[2], FilterToken) then
            FilterOnKey(NewLineRecoredRef, KeyNames[2], FilterToken.AsValue().AsText());

        if NewLineRecoredRef.FindLast() then begin
            FldRef := NewLineRecoredRef.Field(GetFieldNumber(NewLineRecoredRef.Number(), LineNoFieldTxt));
            NextLineNo := FldRef.Value();
            NextLineNo += 10000;
        end else
            NextLineNo := 10000;

        InsertNewLine(NewLineRecoredRef, SourceRecordRef, NextLineNo, KeyNames, Parameters);
    end;

    /// <summary>
    /// InsertNewLine.
    /// </summary>
    /// <param name="NewLineRecordRef">VAR RecordRef.</param>
    /// <param name="SourceRecordRef">VAR RecordRef.</param>
    /// <param name="NewLineNo">Integer.</param>
    /// <param name="KeyNames">array[2] of Text.</param>
    /// <param name="Parameters">JsonObject.</param>
    local procedure InsertNewLine(var NewLineRecordRef: RecordRef; var SourceRecordRef: RecordRef; NewLineNo: Integer; KeyNames: array[2] of Text; Parameters: JsonObject)
    var
        FldRef: FieldRef;
        JToken: JsonToken;
        TypeNameTxt: Label 'Type';
    begin
        NewLineRecordRef.Init();

        if NewLineRecordRef.Number() = Database::"Item Journal Line" then
            DefaultJournalLine(SourceRecordRef, NewLineRecordRef)
        else begin
            // fill key 1 field
            FldRef := NewLineRecordRef.Field(GetFieldNumber(NewLineRecordRef.Number(), KeyNames[1]));
            if Parameters.Get(KeyNames[1], JToken) then
                if KeyNames[1] = DocumentKeys[1] then
                    FldRef.Validate(JToken.AsValue().AsInteger())
                else
                    FldRef.Value := CopyStr(JToken.AsValue().AsText(), 1, FldRef.Length());

            // fill key 2 field
            FldRef := NewLineRecordRef.Field(GetFieldNumber(NewLineRecordRef.Number(), KeyNames[2]));
            if Parameters.Get(KeyNames[2], JToken) then
                FldRef.Value := CopyStr(JToken.AsValue().AsText(), 1, FldRef.Length());
        end;

        // fill key 3 field (line no.)
        FldRef := NewLineRecordRef.Field(GetFieldNumber(NewLineRecordRef.Number(), LineNoFieldTxt));
        FldRef.Value := NewLineNo;

        // fill Type field for Sales and Purchase lines.
        if NewLineRecordRef.Number() in [Database::"Sales Line", Database::"Purchase Line"] then begin
            FldRef := NewLineRecordRef.Field(GetFieldNumber(NewLineRecordRef.Number(), TypeNameTxt));
            FldRef.Validate(2);
        end;

        // fill item no field        
        FldRef := NewLineRecordRef.Field(GetFieldNumber(NewLineRecordRef.Number(), ItemNoFieldTxt));
        if Parameters.Get(ItemNoFieldTxt, JToken) then
            FldRef.Validate(Jtoken.AsValue().AsText());

        NewLineRecordRef.Insert(true);
    end;

    /// <summary>
    /// DefaultJournalLine.
    /// </summary>
    /// <param name="SourceRecordRef">RecordRef.</param>
    /// <param name="NewRecordRef">VAR RecordRef.</param>
    local procedure DefaultJournalLine(SourceRecordRef: RecordRef; var NewRecordRef: RecordRef)
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLine2: Record "Item Journal Line";
    begin
        SourceRecordRef.SetTable(ItemJnlLine);
        ItemJnlLine2.SetupNewLine(ItemJnlLine);
        NewRecordRef.GetTable(ItemJnlLine2);
    end;

    /// <summary>
    /// FilterOnKey.
    /// </summary>
    /// <param name="RecordRefToFilter">VAR RecordRef.</param>
    /// <param name="FieldName">Text.</param>
    /// <param name="FilterValue">Variant.</param>
    local procedure FilterOnKey(var RecordRefToFilter: RecordRef; FieldName: Text; FilterValue: Variant)
    var
        FilterFieldRef: FieldRef;
        FieldNumber: Integer;
    begin
        FieldNumber := GetFieldNumber(RecordRefToFilter.Number(), FieldName);
        FilterFieldRef := RecordRefToFilter.Field(FieldNumber);
        FilterFieldRef.SetFilter(FilterValue);
    end;

    /// <summary>
    /// GetFieldNumber.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <param name="FieldName">Text.</param>
    /// <returns>Return variable ReturnValue of type Integer.</returns>
    procedure GetFieldNumber(TableNo: Integer; FieldName: Text) ReturnValue: Integer;
    var
        FieldTable: Record Field;
        FilterTxt: Label '@%1';
    begin
        FieldTable.SetRange(TableNo, TableNo);
        FieldTable.SetFilter(FieldName, StrSubstNo(FilterTxt, FieldName));
        if not FieldTable.FindFirst() then
            exit;

        ReturnValue := FieldTable."No.";
    end;
}