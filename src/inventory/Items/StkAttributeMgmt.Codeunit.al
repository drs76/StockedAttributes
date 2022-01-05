/// <summary>
/// Codeunit PTEStkAttributeMgmt (ID 50100).
/// </summary>
codeunit 50100 PTEStkAttributeMgmt
{
    /// <summary>
    /// RunSciNetDirectDebitWizard.
    /// </summary>
    /// <param name="DirectDebitNotify">Notification.</param>
    procedure RunAssistedSetup(DirectDebitNotify: Notification)
    begin
        Page.Run(Page::PTEStkAttributeAssistedSetup);
    end;

    /// <summary>
    /// IsEnabled.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsEnabled(): Boolean;
    var
        StkAttributeSetup: Record PTEStkAttributeSetup;
    begin
        if not StkAttributeSetup.Get() then
            exit(false);
        exit(StkAttributeSetup.Enabled);
    end;

    /// <summary>
    /// CreateAllPossibleVariants.
    /// </summary>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="ShowVariants">Boolean.</param>
    procedure CreateAllPossibleVariants(ItemNo: Code[20]; ShowVariants: Boolean)
    var
        ItemToCreateVariantFor: Record Item;
        tempAttributeSetEntry: Record PTEStkAttributeSetEntry temporary;
        CombinedAttributeList: List of [Text];
        Window: Dialog;
        x: Integer;
        Seperator: Char;
        NotAllRemovedMsg: Label 'Warning : Not all current Item Variant records were removed before re-creation';
        CreatingForMsg: Label 'Creating #1########\#2######################';
    begin
        ItemToCreateVariantFor.Get(ItemNo);
        ItemToCreateVariantFor.TestField(PTEStkAttributeTemplateCode);

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
        CheckUpdateItemSearchTerms(ItemToCreateVariantFor, ItemToCreateVariantFor.PTEStkAttributeTemplateCode);
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
        PTEStkAttributeTemplate: Record PTEStkAttributeTemplate;
        StockedAttrTemplateEntry: Record PTEStkAttributeTemplateEntry;
        AttributeList: List of [Text];
        CurrentAttribute: Integer;
    begin
        // Using the Stocked Attibrutes assigned to the item, build a list of unique combinations of the
        // attributes, which will be used to create the variants.     
        PTEStkAttributeTemplate.Get(ItemToCreateFor.PTEStkAttributeTemplateCode);

        StockedAttrTemplateEntry.SetRange(TemplateID, PTEStkAttributeTemplate."Template Set ID");
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
    /// <param name="StkAttributeList">VAR List of [Text].</param>
    /// <param name="AttributeList">List of [Text].</param>
    /// <param name="Seperator">Text[1].</param>
    local procedure CodeCombine(var StkAttributeList: List of [Text]; AttributeList: List of [Text]; Seperator: Text[1])
    var
        NewList: List of [Text];
        x: Integer;
        y: Integer;
    begin
        // concatentate entries from each list to each other using the provided seperator
        for x := 1 to StkAttributeList.Count() do
            for y := 1 to AttributeList.Count() do
                NewList.Add(FormatAttributeListEntry(StkAttributeList.Get(x), AttributeList.Get(y), Seperator));

        Clear(StkAttributeList);
        StkAttributeList.AddRange(NewList);
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
    /// <param name="tempAttributeSetEntry">Temporary VAR Record PTEStkAttributeSetEntry.</param>
    /// <param name="CodeString">Text.</param>
    /// <param name="Seperator">Text[1].</param>
    local procedure CreateVariantSet(var tempAttributeSetEntry: Record PTEStkAttributeSetEntry temporary; CodeString: Text; Seperator: Text[1])
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
    /// <param name="tempAttributeSetEntry">Temporary VAR Record PTEStkAttributeSetEntry.</param>
    local procedure CreateVariant(ItemToCreateFor: Record Item; var tempAttributeSetEntry: Record PTEStkAttributeSetEntry temporary)
    var
        ItemVariant: Record "Item Variant";
        AttributeSetID: Integer;
        VariantDescriptionTxt: Label '%1 %2';
    begin
        AttributeSetID := GetAttributeSetID(tempAttributeSetEntry);

        Clear(ItemVariant);
        ItemVariant.SetRange("Item No.", ItemToCreateFor."No.");
        ItemVariant.SetRange(PTEStkAttributeSetId, AttributeSetID);
        if not ItemVariant.FindFirst() then begin
            ItemVariant.Validate("Item No.", ItemToCreateFor."No.");
            ItemVariant.Validate(Code, GetNextVariantCode(ItemToCreateFor."No."));
            ItemVariant.Insert(true);
        end;
        ItemVariant.Validate(Description, CopyStr(StrSubStno(VariantDescriptionTxt, ItemToCreateFor.Description, AttributeSetID), 1, MaxStrLen(ItemVariant.Description)));
        ItemVariant.Validate(PTEStkAttributeSetId, AttributeSetID);
        ItemVariant.Modify(true);
    end;

    /// <summary>
    /// CheckUpdateItemSearchTerms.
    /// </summary>
    /// <param name="ItemToUpdate">Record Item.</param>
    /// <param name="TemplateCode">Code[20].</param>
    procedure CheckUpdateItemSearchTerms(ItemToUpdate: Record Item; TemplateCode: Code[20])
    var
        StockAttributeTemplate: Record PTEStkAttributeTemplate;
        StkAttributeTempltEntry: Record PTEStkAttributeTemplateEntry;
    begin
        ModifySearchTerms(ItemToUpdate, ItemToUpdate.Description);
        ModifySearchTerms(ItemToUpdate, ItemToUpdate."Description 2");
        ItemToUpdate.Modify();

        if not StockAttributeTemplate.Get(TemplateCode) then
            exit;

        StkAttributeTempltEntry.SetRange(TemplateID, StockAttributeTemplate."Template Set ID");
        if not StkAttributeTempltEntry.FindSet() then
            exit;

        repeat
            StkAttributeTempltEntry.CalcFields("Attribute Value");
            ModifySearchTerms(ItemToUpdate, StkAttributeTempltEntry."Attribute Value");
        until StkAttributeTempltEntry.Next() = 0;

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
        if ItemToUpdate.PTEStkAttributeSearchText.Contains(SearchValue) then
            exit;

        if ItemToUpdate.PTEStkAttributeSearchText2.Contains(SearchValue) then
            exit;

        for i := 1 to StrLen(BadCharsTxt) do
            SearchValue := DelChr(SearchValue, WhereLbl, Format(BadCharsTxt) [i]);

        if StrLen(StrSubstNo(SearchTxt, ItemToUpdate.PTEStkAttributeSearchText, SearchValue)) <= MaxStrLen(ItemToUpdate.PTEStkAttributeSearchText) then
            ItemToUpdate.PTEStkAttributeSearchText := StrSubstNo(SearchTxt, ItemToUpdate.PTEStkAttributeSearchText, SearchValue)
        else
            if StrLen(StrSubstNo(SearchTxt, ItemToUpdate.PTEStkAttributeSearchText, SearchValue)) <= MaxStrLen(ItemToUpdate.PTEStkAttributeSearchText) then
                ItemToUpdate.PTEStkAttributeSearchText := StrSubstNo(SearchTxt, ItemToUpdate.PTEStkAttributeSearchText, SearchValue)
            else
                Error('We need another PTEStkAttributeSearchText field!');
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
    /// <param name="StockedAttributeTemplate">Record PTEStkAttributeTemplate.</param>
    procedure EditStockedAttributeTemplate(StockedAttributeTemplate: Record PTEStkAttributeTemplate)
    var
        StkAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry;
        StkAttributesPage: Page PTEStkAttributeTemplateSets;
    begin
        StkAttributeTemplateEntry.FilterGroup(2);
        StkAttributeTemplateEntry.SetRange(TemplateID, StockedAttributeTemplate."Template Set ID");
        StkAttributeTemplateEntry.FilterGroup(0);

        StkAttributesPage.SetTemplate(StockedAttributeTemplate);
        StkAttributesPage.SetTableView(StkAttributeTemplateEntry);
        StkAttributesPage.RunModal();
    end;

    /// <summary>
    /// ShowVariantAttributes.
    /// </summary>
    /// <param name="VariantAttributeSetID">Integer.</param>
    procedure ShowVariantAttributes(VariantAttributeSetID: Integer)
    var
        StkAttributeSetEntry: Record PTEStkAttributeSetEntry;
        StkAttributeSetsPage: Page PTEStkAttributeSets;
    begin
        StkAttributeSetEntry.FilterGroup(2);
        StkAttributeSetEntry.SetRange(AttributeSetID, VariantAttributeSetID);
        StkAttributeSetEntry.FilterGroup(0);

        StkAttributeSetsPage.SetTableView(StkAttributeSetEntry);
        StkAttributeSetsPage.RunModal();
    end;

    /// <summary>
    /// GetAttributeSetID.
    /// </summary>
    /// <param name="StkAttributeSetEntry2">VAR Record PTEStkAttributeSetEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetAttributeSetID(var StkAttributeSetEntry2: Record PTEStkAttributeSetEntry): Integer;
    var
        StkAttributeSetEntry: Record PTEStkAttributeSetEntry;
    begin
        exit(StkAttributeSetEntry.GetAttributeSetID(StkAttributeSetEntry2));
    end;

    /// <summary>
    /// GetAttributeSet.
    /// </summary>
    /// <param name="TempAttributeSetEntry">Temporary VAR Record PTEStkAttributeSetEntry.</param>
    /// <param name="AttributeSetID">Integer.</param>
    procedure GetAttributeSet(var TempAttributeSetEntry: Record PTEStkAttributeSetEntry temporary; AttributeSetID: Integer)
    var
        PTEStkAttributeSetEntry: Record PTEStkAttributeSetEntry;
    begin
        clear(TempAttributeSetEntry);
        TempAttributeSetEntry.DeleteAll();

        PTEStkAttributeSetEntry.SETRANGE(AttributeSetID, AttributeSetID);
        if PTEStkAttributeSetEntry.FindSet() then
            repeat
                TempAttributeSetEntry := PTEStkAttributeSetEntry;
                TempAttributeSetEntry.Insert();
            until PTEStkAttributeSetEntry.Next() = 0;
    end;

    /// <summary>
    /// GetAttributeTemplateSetID.
    /// </summary>
    /// <param name="StkAttributeTemplateEntry2">VAR Record PTEStkAttributeTemplateEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetAttributeTemplateSetID(var StkAttributeTemplateEntry2: Record PTEStkAttributeTemplateEntry): Integer;
    var
        StkAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry;
    begin
        exit(StkAttributeTemplateEntry.GetTemplateSetID(StkAttributeTemplateEntry2));
    end;

    /// <summary>
    /// GetAttributeTemplateSet.
    /// </summary>
    /// <param name="TempAttributeTemplateSet">Temporary VAR Record PTEStkAttributeTemplateEntry.</param>
    /// <param name="TemplateSetID">Integer.</param>
    procedure GetAttributeTemplateSet(var TempAttributeTemplateSet: Record PTEStkAttributeTemplateEntry temporary; TemplateSetID: Integer)
    var
        StkAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry;
    begin
        TempAttributeTemplateSet.DeleteAll();

        StkAttributeTemplateEntry.SetRange(TemplateID, TemplateSetID);
        if StkAttributeTemplateEntry.FindSet() then
            repeat
                TempAttributeTemplateSet := StkAttributeTemplateEntry;
                TempAttributeTemplateSet.Insert();
            until StkAttributeTemplateEntry.Next() = 0;
    end;

    /// <summary>
    /// GetVariantFullDescription.
    /// </summary>
    /// <param name="Item">Record Item.</param>
    /// <param name="VariantAttributeSetID">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetVariantFullDescription(Item: Record Item; VariantAttributeSetID: Integer): Text;
    var
        StkAttributeSetEntry: Record PTEStkAttributeSetEntry;
        FullDescriptionTB: TextBuilder;
        AttributeFormatTxt: Label '%1: %2';
        AttributeseperatorTxt: Label '; ';
    begin
        StkAttributeSetEntry.SetRange(AttributeSetID, VariantAttributeSetID);
        if not StkAttributeSetEntry.FindSet() then
            exit(Item.Description);

        FullDescriptionTB.Append(Item.Description);
        repeat
            StkAttributeSetEntry.CalcFields("Attribute Code", "Attribute Value");

            if FullDescriptionTB.Length() > 0 then
                FullDescriptionTB.Append(AttributeseperatorTxt);

            FullDescriptionTB.Append(StrSubstNo(AttributeFormatTxt, StkAttributeSetEntry."Attribute Code", StkAttributeSetEntry."Attribute Value"));
        until StkAttributeSetEntry.Next() = 0;

        exit(FullDescriptionTB.ToText());
    end;

    /// <summary>
    /// CopyAttributesToTemplate.
    /// </summary>
    /// <param name="TempStockedAttributeTemplateEntry">Temporary VAR Record PTEStkAttributeTemplateEntry.</param>
    procedure CopyAttributesToTemplate(var TempStockedAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry temporary)
    var
        TempStockedAttributeTemplateEntry2: Record PTEStkAttributeTemplateEntry temporary;
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
    /// <param name="TempStockedAttributeTemplateEntry">Temporary VAR Record PTEStkAttributeTemplateEntry.</param>
    local procedure TransferAttributesToTemplate(AttributeView: Text; var TempStockedAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry temporary)
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributesQuery: Query PTEStkAttributeItemAttributes;
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