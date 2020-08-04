codeunit 50100 StockedAttributeMgmt
{
    procedure IsEnabled(): Boolean;
    var
        StockedAttributeSetup: Record StockedAttributeSetup;
    begin
        if not StockedAttributeSetup.Get() then
            exit(false);
        exit(StockedAttributeSetup.Enabled);
    end;

    procedure CreateAllPossibleVariants(ItemNo: Code[20]; ShowVariants: Boolean)
    var
        ItemToCreateVariantFor: Record Item;
        tempAttributeSetEntry: Record StockedAttributeSetEntry temporary;
        CombinedAttributeList: List of [Text];
        Window: Dialog;
        x: Integer;
        Seperator: Char;
        NotAllRemovedMsg: Label 'Warning : not all existing Item Variant records were removed before re-creation';
        CreatingForMsg: Label 'Creating #1#######';
    begin
        ItemToCreateVariantFor.Get(ItemNo);

        if not RemoveCurrentVariants(ItemNo) then
            Message(NotAllRemovedMsg);

        Seperator := 177; // used for seperating the attribute entries when combining
        BuildCombinedAttributesList(ItemToCreateVariantFor, CombinedAttributeList, Seperator);

        if GuiAllowed() then
            Window.Open(CreatingForMsg);

        // loop through combinations and create variant records
        for x := 1 to CombinedAttributeList.Count() do begin
            if GuiAllowed() then
                Window.Update(1, CombinedAttributeList.Get(x));

            tempAttributeSetEntry.DeleteAll();
            CreateVariantSet(tempAttributeSetEntry, CombinedAttributeList.Get(x), Format(Seperator));
            if tempAttributeSetEntry.FindFirst() then
                CreateVariant(ItemToCreateVariantFor, tempAttributeSetEntry);
        end;

        if GuiAllowed() then
            Window.Close();

        if ShowVariants then begin
            Commit();
            ShowVariants(ItemNo);
        end;
    end;

    local procedure BuildCombinedAttributesList(ItemToCreateFor: Record Item; var CombinedAttributeList: List of [Text]; Seperator: Text[1]);
    var
        StockedAttributeTemplate: Record StockedAttributeTemplate;
        StockedAttrTemplateEntry: Record StockedAttributeTemplateEntry;
        AttributeList: List of [Text];
        CurrentAttribute: Integer;
    begin
        // Using the Stocked Attibrutes assigned to the item, build a list of unique combinations of the
        // attributes, which will be used to create the variants.     
        StockedAttributeTemplate.Get(ItemToCreateFor.StockedAttributeTemplateCode);

        StockedAttrTemplateEntry.SetRange(TemplateID, StockedAttributeTemplate."Template Set ID");
        if not StockedAttrTemplateEntry.FindSet() then
            exit;

        CurrentAttribute := StockedAttrTemplateEntry.AttributeID;
        repeat
            if StockedAttrTemplateEntry.AttributeID <> CurrentAttribute then
                CombineLists(AttributeList, CombinedAttributeList, Seperator);

            // Each attribute list entry is attribute and value id's seperated provided charavter.            
            AttributeList.Add(FormatAttributeListEntry(Format(StockedAttrTemplateEntry.AttributeID), Format(StockedAttrTemplateEntry.AttributeValueID), Seperator));

            CurrentAttribute := StockedAttrTemplateEntry.AttributeID;
        until StockedAttrTemplateEntry.Next() = 0;

        CombineLists(AttributeList, CombinedAttributeList, Seperator);
    end;

    local procedure CombineLists(var InList: List of [Text]; var CombinedList: List of [Text]; Seperator: Text[1])
    begin
        if CombinedList.Count() > 0 then
            CodeCombine(CombinedList, InList, Seperator) // combine the lists
        else
            CombinedList.AddRange(InList);
        Clear(InList); // empty InList
    end;

    local procedure CodeCombine(Var StockedAttributeList: List of [Text]; AttributeList: List of [Text]; Seperator: Text[1])
    var
        NewList: List of [Text];
        x: Integer;
        y: Integer;
    begin
        // concatentate entries from each list to each other using the provided seperator
        for x := 1 to StockedAttributeList.Count() do
            for y := 1 to AttributeList.Count() do
                NewList.Add(FormatAttributeListEntry(StockedAttributeList.Get(x), AttributeList.Get(y), Seperator));

        Clear(StockedAttributeList);
        StockedAttributeList.AddRange(NewList);
    end;

    local procedure FormatAttributeListEntry(AttributeID: Text; AttributeValueID: Text; Seperator: Text[1]): Text;
    var
        AttributeEntryTxt: Label '%1%2%3';
    begin
        exit(StrSubStno(AttributeEntryTxt, AttributeID, Seperator, AttributeValueID));
    end;

    local procedure CreateVariantSet(var tempAttributeSetEntry: Record StockedAttributeSetEntry temporary; CodeString: Text; Seperator: Text[1])
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        AttributeID: Integer;
        ValueID: Integer;
    begin
        while StrLen(CodeString) > 0 do begin
            Evaluate(AttributeID, CopyStr(StripCode(CodeString, Seperator), 1, 10));
            Evaluate(ValueID, CopyStr(StripCode(CodeString, Seperator), 1, 10));

            ItemAttribute.Get(AttributeID);
            ItemAttributeValue.Get(AttributeID, ValueID);

            tempAttributeSetEntry.Init();
            tempAttributeSetEntry.AttributeSetID := -1;
            tempAttributeSetEntry.AttributeID := ItemAttribute.ID;
            tempAttributeSetEntry.AttributeValueID := ItemAttributeValue.ID;
            tempAttributeSetEntry.Insert();
        end;
    end;

    local procedure StripCode(var InString: Text; Seperator: Text[1]): Text
    var
        CodeString: Text;
    begin
        if StrPos(InString, Seperator) > 0 then begin
            CodeString := CopyStr(InString, 1, StrPos(InString, Seperator) - 1);
            InString := CopyStr(InString, StrPos(InString, Seperator) + 1, StrLen(InString));
        end else begin
            CodeString := InString;
            Clear(InString);
        end;

        exit(CodeString);
    end;

    local procedure CreateVariant(ItemToCreateFor: Record Item; var tempAttributeSetEntry: Record StockedAttributeSetEntry temporary)
    var
        ItemVariant: Record "Item Variant";
        AttributeSetID: Integer;
        VariantDescriptionTxt: Label '%1 %2';
    begin
        AttributeSetID := GetAttributeSetID(tempAttributeSetEntry);

        Clear(ItemVariant);
        ItemVariant.SetRange("Item No.", ItemToCreateFor."No.");
        ItemVariant.SetRange("Attribute Set ID", AttributeSetID);
        if not ItemVariant.FindFirst() then begin
            ItemVariant."Item No." := ItemToCreateFor."No.";
            ItemVariant.Code := GetNextVariantCode(ItemToCreateFor."No.");
            ItemVariant.Insert(true);
        end;
        ItemVariant.Description := CopyStr(StrSubStno(VariantDescriptionTxt, ItemToCreateFor.Description, AttributeSetID), 1, MaxStrLen(ItemVariant.Description));
        ItemVariant."Attribute Set ID" := AttributeSetID;
        ItemVariant.Modify();
    end;

    local procedure RemoveCurrentVariants(ItemNo: Code[20]): Boolean
    var
        ItemVariant: Record "Item Variant";
        ItemVariant2: Record "Item Variant";
        AllRemoved: Boolean;
    begin
        AllRemoved := true;
        ItemVariant.SetRange("Item No.", ItemNo);
        if ItemVariant.FindSet() then
            repeat
                ItemVariant2 := ItemVariant;
                if not ItemVariant2.Delete(true) then
                    AllRemoved := false;
            until ItemVariant.Next() = 0;

        exit(AllRemoved);
    end;

    local procedure GetNextVariantCode(ItemNo: Code[20]): Code[10]
    var
        ItemVariant: Record "Item Variant";
        DefaultValueTxt: Label 'V1000';
    begin
        ItemVariant.SetRange("Item No.", ItemNo);
        if ItemVariant.FindLast() then
            exit(CopyStr(IncStr(ItemVariant.Code), 1, 10))
        ELSE
            exit(DefaultValueTxt);
        Clear(ItemVariant);
    end;

    local procedure ShowVariants(ItemNo: Code[20])
    var
        ItemVariant: Record "Item Variant";
    begin
        ItemVariant.FilterGroup(2);
        ItemVariant.SetRange("Item No.", ItemNo);

        Page.RunModal(Page::"Item Variants", ItemVariant);
    end;

    procedure EditStockedAttributeTemplate(StockedAttributeTemplate: Record StockedAttributeTemplate)
    var
        StockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry;
        StockedAttributesPage: Page StockedAttributeTemplateSets;
    begin
        StockedAttributeTemplateEntry.FilterGroup(2);
        StockedAttributeTemplateEntry.SetRange(TemplateID, StockedAttributeTemplate."Template Set ID");
        StockedAttributeTemplateEntry.FilterGroup(0);

        StockedAttributesPage.SetTemplate(StockedAttributeTemplate);
        StockedAttributesPage.SetTableView(StockedAttributeTemplateEntry);
        StockedAttributesPage.RunModal();
    end;

    procedure ShowVariantAttributes(VariantAttributeSetID: Integer)
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
        StockedAttributeSetsPage: Page StockedAttributeSets;
        NewAttributeSetID: Integer;
    begin
        NewAttributeSetID := VariantAttributeSetID;
        StockedAttributeSetEntry.FilterGroup(2);
        StockedAttributeSetEntry.SetRange(AttributeSetID, VariantAttributeSetID);
        StockedAttributeSetEntry.FilterGroup(0);

        StockedAttributeSetsPage.SetTableView(StockedAttributeSetEntry);
        StockedAttributeSetsPage.RunModal();
    end;

    procedure GetAttributeSetID(var StockedAttributeSetEntry2: Record StockedAttributeSetEntry): Integer;
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
    begin
        exit(StockedAttributeSetEntry.GetAttributeSetID(StockedAttributeSetEntry2));
    end;

    procedure GetAttributeSet(var TempAttributeSetEntry: Record StockedAttributeSetEntry temporary; AttributeSetID: Integer)
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
    begin
        clear(TempAttributeSetEntry);
        TempAttributeSetEntry.DeleteAll();

        StockedAttributeSetEntry.SETRANGE(AttributeSetID, AttributeSetID);
        if StockedAttributeSetEntry.FindSet() then
            repeat
                TempAttributeSetEntry := StockedAttributeSetEntry;
                TempAttributeSetEntry.Insert();
            until StockedAttributeSetEntry.Next() = 0;
    end;

    procedure GetAttributeTemplateSetID(var StockedAttributeTemplateEntry2: Record StockedAttributeTemplateEntry): Integer;
    var
        StockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry;
    begin
        exit(StockedAttributeTemplateEntry.GetTemplateSetID(StockedAttributeTemplateEntry2));
    end;

    procedure GetAttributeTemplateSet(var TempAttributeTemplateSet: Record StockedAttributeTemplateEntry temporary; TemplateSetID: Integer)
    var
        StockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry;
    begin
        TempAttributeTemplateSet.DeleteAll();

        StockedAttributeTemplateEntry.SetRange(TemplateID, TemplateSetID);
        if StockedAttributeTemplateEntry.FindSet() then
            repeat
                TempAttributeTemplateSet := StockedAttributeTemplateEntry;
                TempAttributeTemplateSet.Insert();
            until StockedAttributeTemplateEntry.Next() = 0;
    end;

    procedure GetVariantFullDescription(Item: Record Item; VariantAttributeSetID: Integer): Text;
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
        FullDescriptionTB: TextBuilder;
        AttributeFormatTxt: Label '%1: %2';
        AttributeseperatorTxt: Label '; ';
    begin
        StockedAttributeSetEntry.SetRange(AttributeSetID, VariantAttributeSetID);
        if not StockedAttributeSetEntry.FindSet() then
            exit(Item.Description);

        FullDescriptionTB.Append(Item.Description);
        repeat
            StockedAttributeSetEntry.CalcFields("Attribute Code", "Attribute Value");

            if FullDescriptionTB.Length() > 0 then
                FullDescriptionTB.Append(AttributeseperatorTxt);

            FullDescriptionTB.Append(StrSubstNo(AttributeFormatTxt, StockedAttributeSetEntry."Attribute Code", StockedAttributeSetEntry."Attribute Value"));
        until StockedAttributeSetEntry.Next() = 0;

        exit(FullDescriptionTB.ToText());
    end;

    procedure CopyAttributesToTemplate(TempStockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary)
    var
        TempStockedAttributeTemplateEntry2: Record StockedAttributeTemplateEntry temporary;
        ItemAttributes: Record "Item Attribute";
        FilterPage: FilterPageBuilder;

    begin
        TempStockedAttributeTemplateEntry2.Copy(TempStockedAttributeTemplateEntry, true);


        FilterPage.AddRecord('Item Attribute', ItemAttributes);
        FilterPage.AddFieldNo('Item Attribute', ItemAttributes.FieldNo(ID));
        if FilterPage.RunModal() then
            Message(FilterPage.GetView('Item Attribute'));

    end;
}