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

    procedure LaunchStockedAttributeConfigurator(RecordIn: Variant)
    var
        TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary;
        SourceRecordRef: RecordRef;
        Parameters: JsonObject;
    begin
        InitFields(); // setup field arrays required.

        SourceRecordRef.GetTable(RecordIn);
        PrepareConfigurator(SourceRecordRef, Parameters);

        if RunAttributeConfigurator(Parameters, TempStockedAttributeDocBuffer) then
            AddSelectionsToDocument(SourceRecordRef, Parameters, TempStockedAttributeDocBuffer);
    end;

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

    procedure RunAttributeConfigurator(Parameters: JsonObject; var TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary) ReturnValue: Boolean;
    var
        AttributeEntryBuffer: Page StockedAttributeConfigurator;
        ItemNo: Text;
        LocationCodeParam: Text;
        UoCodeParam: Text;
    begin
        SetupPageParams(Parameters, ItemNo, LocationCodeParam, UoCodeParam);
        if ItemNo = '' then
            exit;

        Commit();

        TempStockedAttributeDocBuffer.FilterGroup(2);
        TempStockedAttributeDocBuffer.SetRange("Item No.", ItemNo);
        TempStockedAttributeDocBuffer.FilterGroup(0);

        AttributeEntryBuffer.SetTableView(TempStockedAttributeDocBuffer);
        AttributeEntryBuffer.SetLineDefaults(LocationCodeParam, UoCodeParam);
        AttributeEntryBuffer.RunModal();

        ReturnValue := AttributeEntryBuffer.SaveSelections();
        if not ReturnValue then
            exit; // Finish on page not selected.

        AttributeEntryBuffer.GetRecords(TempStockedAttributeDocBuffer);
    end;

    local procedure SetupPageParams(Parameters: JsonObject; var ItemNo: Text; var LocationCode: Text; var UoM: Text)
    var
        JToken: JsonToken;
    begin
        if Parameters.Get(ItemNoFieldTxt, JToken) then
            ItemNo := JToken.AsValue().AsText();

        if Parameters.Get(LocationCodeFieldTxt, JToken) then
            LocationCode := JToken.AsValue().AsText();

        if Parameters.Get(UoMFieldTxt, JToken) then
            UoM := JToken.AsValue().AsText();
    end;

    local procedure AddSelectionsToDocument(SourceRecordRef: RecordRef; Parameters: JsonObject; var TempStockedAttributeDocBuffer: Record StockedAttributeDocEntryBuffer temporary)
    var
        NewLineRecordRef: RecordRef;
        VariantFieldNo: Integer;
        QuantityFieldNo: Integer;
        UoMFieldNo: Integer;
        LocationFieldNo: Integer;
        VariantCodeFieldNameTxt: Label 'Variant Code';
        QuantityFieldNameTxt: Label 'Quantity';
        UoMFieldNameTxt: Label 'Unit of Measure Code';
    begin
        if TempStockedAttributeDocBuffer.FindSet() then begin
            SourceRecordRef.Find('=');

            VariantFieldNo := GetFieldNumber(SourceRecordRef.Number(), VariantCodeFieldNameTxt);
            QuantityFieldNo := GetFieldNumber(SourceRecordRef.Number(), QuantityFieldNameTxt);
            UoMFieldNo := GetFieldNumber(SourceRecordRef.Number(), UoMFieldNameTxt);
            LocationFieldNo := GetFieldNumber(SourceRecordRef.Number(), LocationCodeFieldTxt);

            // Update fields on source line
            UpdateRecordRef(SourceRecordRef, VariantFieldNo, TempStockedAttributeDocBuffer."Variant Code");
            UpdateRecordRef(SourceRecordRef, QuantityFieldNo, TempStockedAttributeDocBuffer.Quantity);
            UpdateRecordRef(SourceRecordRef, UoMFieldNo, TempStockedAttributeDocBuffer.UnitofMeasureCode);
            UpdateRecordRef(SourceRecordRef, LocationFieldNo, TempStockedAttributeDocBuffer.LocationCode);
            SourceRecordRef.Modify();

            // Add any additional selections to the document.
            if TempStockedAttributeDocBuffer.Next() <> 0 then
                repeat
                    // Add new line
                    AddLine(NewLineRecordRef, SourceRecordRef, Parameters);

                    // Update field on new line
                    UpdateRecordRef(NewLineRecordRef, VariantFieldNo, TempStockedAttributeDocBuffer."Variant Code");
                    UpdateRecordRef(NewLineRecordRef, QuantityFieldNo, TempStockedAttributeDocBuffer.Quantity);
                    UpdateRecordRef(NewLineRecordRef, UoMFieldNo, TempStockedAttributeDocBuffer.UnitofMeasureCode);
                    UpdateRecordRef(NewLineRecordRef, LocationFieldNo, TempStockedAttributeDocBuffer.LocationCode);
                    NewLineRecordRef.Modify(true);
                until TempStockedAttributeDocBuffer.Next() = 0;
        end;
    end;

    local procedure UpdateRecordRef(var RecordRefToUpdate: RecordRef; FieldNumber: Integer; FieldValue: Variant)
    var
        FieldRefToSet: FieldRef;
    begin
        FieldRefToSet := RecordRefToUpdate.Field(FieldNumber);
        FieldRefToSet.Validate(FieldValue);
    end;

    local procedure AddLine(var NewLineRecoredRef: RecordRef; SourceRecordRef: RecordRef; Parameters: JsonObject)
    var
        FldRef: FieldRef;
        FilterToken: JsonToken;
        KeyNames: array[2] of Text;
        NextLineNo: Integer;
    begin
        NewLineRecoredRef.Open(SourceRecordRef.Number());

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

    local procedure DefaultJournalLine(SourceRecordRef: RecordRef; var NewRecordRef: RecordRef)
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLine2: Record "Item Journal Line";
    begin
        SourceRecordRef.SetTable(ItemJnlLine);
        ItemJnlLine2.SetupNewLine(ItemJnlLine);
        NewRecordRef.GetTable(ItemJnlLine2);
    end;

    local procedure FilterOnKey(var RecordRefToFilter: RecordRef; FieldName: Text; FilterValue: Variant)
    var
        FilterFieldRef: FieldRef;
        FieldNumber: Integer;
    begin
        FieldNumber := GetFieldNumber(RecordRefToFilter.Number(), FieldName);
        FilterFieldRef := RecordRefToFilter.Field(FieldNumber);
        FilterFieldRef.SetFilter(FilterValue);
    end;

    local procedure GetFieldNumber(TableNo: Integer; FieldName: Text) ReturnValue: Integer;
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