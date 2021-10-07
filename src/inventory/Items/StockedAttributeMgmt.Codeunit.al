/// <summary>
/// Codeunit StockedAttributeMgmt (ID 50100).
/// </summary>
codeunit 50100 StockedAttributeMgmt
{
    /// <summary>
    /// IsEnabled.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsEnabled(): Boolean;
    var
        StockedAttributeSetup: Record StockedAttributeSetup;
    begin
        if not StockedAttributeSetup.Get() then
            exit(false);
        exit(StockedAttributeSetup.Enabled);
    end;

    /// <summary>
    /// CreateAllPossibleVariants.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="ShowVariants">Boolean.</param>
    procedure CreateAllPossibleVariants(ItemNo: Code[20]; ShowVariants: Boolean)
    var
        ItemToCreateVariantFor: Record Item;
        tempAttributeSetEntry: Record StockedAttributeSetEntry temporary;
        CombinedAttributeList: List of [Text];
        Window: Dialog;
        x: Integer;
        Seperator: Char;
        NotAllRemovedMsg: Label 'Warning : Not all current Item Variant records were removed before re-creation';
        CreatingForMsg: Label 'Creating #1########\#2######################';
    begin
        ItemToCreateVariantFor.Get(ItemNo);
        ItemToCreateVariantFor.TestField(StockedAttributeTemplateCode);

        if not RemoveCurrentVariants(ItemNo) then
            if ShowVariants then
                Message(NotAllRemovedMsg);

        Seperator := 177; // used for seperating the attribute entries when combining
        BuildCombinedAttributesList(ItemToCreateVariantFor, CombinedAttributeList, Seperator);

        if GuiAllowed() then begin
            Window.Open(CreatingForMsg);
            Window.Update(1, ItemNo);
        end;

        for x := 1 to CombinedAttributeList.Count() do begin
            if GuiAllowed() then
                Window.Update(2, CombinedAttributeList.Get(x));
            tempAttributeSetEntry.DeleteAll();
            CreateVariantSet(tempAttributeSetEntry, CombinedAttributeList.Get(x), Format(Seperator));
            if tempAttributeSetEntry.FindFirst() then
                CreateVariant(ItemToCreateVariantFor, tempAttributeSetEntry);
        end;

        // update the item search fields.
        CheckUpdateItemSearchTerms(ItemToCreateVariantFor, ItemToCreateVariantFor.StockedAttributeTemplateCode);
        if GuiAllowed() then
            Window.Close();

        if ShowVariants then begin
            Commit();
            ShowVariants(ItemNo);
        end;
    end;

    /// <summary>
    /// BuildCombinedAttributesList.
    /// </summary>
    /// <param name="ItemToCreateFor">Record Item.</param>
    /// <param name="CombinedAttributeList">VAR List of [Text].</param>
    /// <param name="Seperator">Text[1].</param>
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

    /// <summary>
    /// CombineLists.
    /// </summary>
    /// <param name="InList">VAR List of [Text].</param>
    /// <param name="CombinedList">VAR List of [Text].</param>
    /// <param name="Seperator">Text[1].</param>
    local procedure CombineLists(var InList: List of [Text]; var CombinedList: List of [Text]; Seperator: Text[1])
    begin
        if CombinedList.Count() > 0 then
            CodeCombine(CombinedList, InList, Seperator) // combine the lists
        else
            CombinedList.AddRange(InList);
        Clear(InList); // empty InList
    end;

    /// <summary>
    /// CodeCombine.
    /// </summary>
    /// <param name="Var StockedAttributeList">List of [Text].</param>
    /// <param name="AttributeList">List of [Text].</param>
    /// <param name="Seperator">Text[1].</param>
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

    /// <summary>
    /// FormatAttributeListEntry.
    /// </summary>
    /// <param name="AttributeID">Text.</param>
    /// <param name="AttributeValueID">Text.</param>
    /// <param name="Seperator">Text[1].</param>
    /// <returns>Return value of type Text.</returns>
    local procedure FormatAttributeListEntry(AttributeID: Text; AttributeValueID: Text; Seperator: Text[1]): Text;
    var
        AttributeEntryTxt: Label '%1%2%3';
    begin
        exit(StrSubStno(AttributeEntryTxt, AttributeID, Seperator, AttributeValueID));
    end;

    /// <summary>
    /// CreateVariantSet.
    /// </summary>
    /// <param name="tempAttributeSetEntry">Temporary VAR Record StockedAttributeSetEntry.</param>
    /// <param name="CodeString">Text.</param>
    /// <param name="Seperator">Text[1].</param>
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
            tempAttributeSetEntry.Insert(true);
        end;
    end;

    /// <summary>
    /// StripCode.
    /// </summary>
    /// <param name="InString">VAR Text.</param>
    /// <param name="Seperator">Text[1].</param>
    /// <returns>Return value of type Text.</returns>
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

    /// <summary>
    /// CreateVariant.
    /// </summary>
    /// <param name="ItemToCreateFor">Record Item.</param>
    /// <param name="tempAttributeSetEntry">Temporary VAR Record StockedAttributeSetEntry.</param>
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
            ItemVariant.Validate("Item No.", ItemToCreateFor."No.");
            ItemVariant.Validate(Code, GetNextVariantCode(ItemToCreateFor."No."));
            ItemVariant.Insert(true);
        end;
        ItemVariant.Validate(Description, CopyStr(StrSubStno(VariantDescriptionTxt, ItemToCreateFor.Description, AttributeSetID), 1, MaxStrLen(ItemVariant.Description)));
        ItemVariant.Validate("Attribute Set ID", AttributeSetID);
        ItemVariant.Modify(true);
    end;

    /// <summary>
    /// CheckUpdateItemSearchTerms.
    /// </summary>
    /// <param name="ItemToUpdate">Record Item.</param>
    /// <param name="TemplateCode">Code[20].</param>
    procedure CheckUpdateItemSearchTerms(ItemToUpdate: Record Item; TemplateCode: Code[20])
    var
        StockAttributeTemplate: Record StockedAttributeTemplate;
        StockedAttributeTempltEntry: Record StockedAttributeTemplateEntry;
    begin
        ModifySearchTerms(ItemToUpdate, ItemToUpdate.Description);
        ModifySearchTerms(ItemToUpdate, ItemToUpdate."Description 2");
        ItemToUpdate.Modify();

        if not StockAttributeTemplate.Get(TemplateCode) then
            exit;

        StockedAttributeTempltEntry.SetRange(TemplateID, StockAttributeTemplate."Template Set ID");
        if not StockedAttributeTempltEntry.FindSet() then
            exit;

        repeat
            StockedAttributeTempltEntry.CalcFields("Attribute Value");
            ModifySearchTerms(ItemToUpdate, StockedAttributeTempltEntry."Attribute Value");
        until StockedAttributeTempltEntry.Next() = 0;

        ItemToUpdate.Modify();
    end;

    /// <summary>
    /// ModifySearchTerms.
    /// </summary>
    /// <param name="ItemToUpdate">Record Item.</param>
    /// <param name="SearchValue">Text.</param>
    local procedure ModifySearchTerms(var ItemToUpdate: Record Item; SearchValue: Text)
    var
        i: Integer;
        SearchTxt: Label '%1 %2', Comment = '%1=Search Text, %2=Additional Search Text';
        BadCharsTxt: Label '()|&*><"%';
        WhereLbl: Label '=';
    begin
        if ItemToUpdate.StockedAttributeSearchText.Contains(SearchValue) then
            exit;

        if ItemToUpdate.StockedAttributeSearchText2.Contains(SearchValue) then
            exit;

        for i := 1 to StrLen(BadCharsTxt) do
            SearchValue := DelChr(SearchValue, WhereLbl, Format(BadCharsTxt) [i]);

        if StrLen(StrSubstNo(SearchTxt, ItemToUpdate.StockedAttributeSearchText, SearchValue)) <= MaxStrLen(ItemToUpdate.StockedAttributeSearchText) then
            ItemToUpdate.StockedAttributeSearchText := StrSubstNo(SearchTxt, ItemToUpdate.StockedAttributeSearchText, SearchValue)
        else
            if StrLen(StrSubstNo(SearchTxt, ItemToUpdate.StockedAttributeSearchText, SearchValue)) <= MaxStrLen(ItemToUpdate.StockedAttributeSearchText) then
                ItemToUpdate.StockedAttributeSearchText := StrSubstNo(SearchTxt, ItemToUpdate.StockedAttributeSearchText, SearchValue)
            else
                Error('We need another StockedAttributeSearchText field!');
    end;

    /// <summary>
    /// RemoveCurrentVariants.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
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

    /// <summary>
    /// GetNextVariantCode.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    /// <returns>Return value of type Code[10].</returns>
    local procedure GetNextVariantCode(ItemNo: Code[20]): Code[10]
    var
        ItemVariant: Record "Item Variant";
        DefaultValueTxt: Label 'VAR1000000';
    begin
        ItemVariant.SetRange("Item No.", ItemNo);
        if ItemVariant.FindLast() then
            exit(CopyStr(IncStr(ItemVariant.Code), 1, 10))
        ELSE
            exit(DefaultValueTxt);
        Clear(ItemVariant);
    end;

    /// <summary>
    /// ShowVariants.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    local procedure ShowVariants(ItemNo: Code[20])
    var
        ItemVariant: Record "Item Variant";
    begin
        ItemVariant.FilterGroup(2);
        ItemVariant.SetRange("Item No.", ItemNo);

        Page.RunModal(Page::"Item Variants", ItemVariant);
    end;

    /// <summary>
    /// EditStockedAttributeTemplate.
    /// </summary>
    /// <param name="StockedAttributeTemplate">Record StockedAttributeTemplate.</param>
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

    /// <summary>
    /// ShowVariantAttributes.
    /// </summary>
    /// <param name="VariantAttributeSetID">Integer.</param>
    procedure ShowVariantAttributes(VariantAttributeSetID: Integer)
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
        StockedAttributeSetsPage: Page StockedAttributeSets;
    begin
        StockedAttributeSetEntry.FilterGroup(2);
        StockedAttributeSetEntry.SetRange(AttributeSetID, VariantAttributeSetID);
        StockedAttributeSetEntry.FilterGroup(0);

        StockedAttributeSetsPage.SetTableView(StockedAttributeSetEntry);
        StockedAttributeSetsPage.RunModal();
    end;

    /// <summary>
    /// GetAttributeSetID.
    /// </summary>
    /// <param name="StockedAttributeSetEntry2">VAR Record StockedAttributeSetEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetAttributeSetID(var StockedAttributeSetEntry2: Record StockedAttributeSetEntry): Integer;
    var
        StockedAttributeSetEntry: Record StockedAttributeSetEntry;
    begin
        exit(StockedAttributeSetEntry.GetAttributeSetID(StockedAttributeSetEntry2));
    end;

    /// <summary>
    /// GetAttributeSet.
    /// </summary>
    /// <param name="TempAttributeSetEntry">Temporary VAR Record StockedAttributeSetEntry.</param>
    /// <param name="AttributeSetID">Integer.</param>
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

    /// <summary>
    /// GetAttributeTemplateSetID.
    /// </summary>
    /// <param name="StockedAttributeTemplateEntry2">VAR Record StockedAttributeTemplateEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetAttributeTemplateSetID(var StockedAttributeTemplateEntry2: Record StockedAttributeTemplateEntry): Integer;
    var
        StockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry;
    begin
        exit(StockedAttributeTemplateEntry.GetTemplateSetID(StockedAttributeTemplateEntry2));
    end;

    /// <summary>
    /// GetAttributeTemplateSet.
    /// </summary>
    /// <param name="TempAttributeTemplateSet">Temporary VAR Record StockedAttributeTemplateEntry.</param>
    /// <param name="TemplateSetID">Integer.</param>
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

    /// <summary>
    /// GetVariantFullDescription.
    /// </summary>
    /// <param name="Item">Record Item.</param>
    /// <param name="VariantAttributeSetID">Integer.</param>
    /// <returns>Return value of type Text.</returns>
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

    /// <summary>
    /// CopyAttributesToTemplate.
    /// </summary>
    /// <param name="TempStockedAttributeTemplateEntry">Temporary VAR Record StockedAttributeTemplateEntry.</param>
    procedure CopyAttributesToTemplate(var TempStockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary)
    var
        TempStockedAttributeTemplateEntry2: Record StockedAttributeTemplateEntry temporary;
        ItemAttributes: Record "Item Attribute";
        FilterPage: FilterPageBuilder;
        ItemAttributeLbl: Label 'Item Attribute';
    begin
        TempStockedAttributeTemplateEntry2.Copy(TempStockedAttributeTemplateEntry, true);

        FilterPage.AddRecord(ItemAttributeLbl, ItemAttributes);
        FilterPage.AddFieldNo(ItemAttributeLbl, ItemAttributes.FieldNo(ID));
        if FilterPage.RunModal() then
            TransferAttributesToTemplate(FilterPage.GetView(ItemAttributeLbl), TempStockedAttributeTemplateEntry2);

        TempStockedAttributeTemplateEntry.Copy(TempStockedAttributeTemplateEntry2, true);
    end;

    /// <summary>
    /// TransferAttributesToTemplate.
    /// </summary>
    /// <param name="AttributeView">Text.</param>
    /// <param name="TempStockedAttributeTemplateEntry">Temporary VAR Record StockedAttributeTemplateEntry.</param>
    local procedure TransferAttributesToTemplate(AttributeView: Text; var TempStockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary)
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributesQuery: Query StockedAttributeItemAttributes;
    begin
        if StrLen(AttributeView) = 0 then
            exit;

        ItemAttribute.SetView(AttributeView);

        ItemAttributesQuery.SetFilter(ID, ItemAttribute.GetFilter(ID));
        ItemAttributesQuery.Open();
        while ItemAttributesQuery.Read() do begin
            TempStockedAttributeTemplateEntry.SetRange(AttributeID, ItemAttributesQuery.ID);
            TempStockedAttributeTemplateEntry.SetRange(AttributeValueID, ItemAttributesQuery.ValueID);
            if not TempStockedAttributeTemplateEntry.FindFirst() then begin
                Clear(TempStockedAttributeTemplateEntry);
                TempStockedAttributeTemplateEntry.AttributeID := ItemAttributesQuery.ID;
                TempStockedAttributeTemplateEntry.AttributeValueID := ItemAttributesQuery.ValueID;
                TempStockedAttributeTemplateEntry.Insert(true);
            end;
        end;
    end;
}