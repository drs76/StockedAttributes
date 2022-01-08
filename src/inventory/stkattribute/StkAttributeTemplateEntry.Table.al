/// <summary>
/// TablePTEStkAttributeTemplateEntry (ID 50104).
/// </summary>
table 50104 PTEStkAttributeTemplateEntry
{
    Caption = 'Stocked Attribute Template Entry';

    fields
    {
        field(1; TemplateID; Integer)
        {
            Caption = 'Template ID';
            DataClassification = CustomerContent;
        }

        field(2; AttributeID; Integer)
        {
            Caption = 'Attribute ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute".ID where(PTEStkAttribute = const(true));
        }

        field(3; AttributeCode; Text[250])
        {
            Caption = 'Attribute';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute".Name where(ID = field(AttributeID)));
            Editable = false;
        }

        field(4; AttributeValueID; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute Value".ID where("Attribute ID" = Field(AttributeID));
        }

        field(5; AttributeValue; Text[250])
        {
            Caption = 'Attribute Value';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute Value".Value where(ID = field(AttributeValueID), "Attribute ID" = field(AttributeID)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; TemplateID, AttributeID, AttributeValueID)
        {
            Clustered = true;
        }
        key(key2; AttributeValueID) { }
        key(Key3; AttributeID, AttributeValueID, TemplateID) { }

    }

    fieldgroups
    {
        fieldgroup(DropDown; AttributeCode, AttributeValue)
        {
        }
        fieldgroup(Brick; AttributeCode, AttributeValue)
        {
        }
    }

    /// <summary>
    /// GetTemplateSetID.
    /// </summary>
    /// <param name="StkAttributeTemplateEntry">VAR Record PTEStkAttributeTemplateEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetTemplateSetID(var StkAttributeTemplateEntry: Record PTEStkAttributeTemplateEntry): Integer;
    var
        StkAttributeTemplateTree: Record PTEStkAttributeTemplateTree;
        StkAttributeTemplateEntry2: Record PTEStkAttributeTemplateEntry;
        Found: Boolean;
    begin
        StkAttributeTemplateEntry2.Copy(StkAttributeTemplateEntry);
        if StkAttributeTemplateEntry.TemplateID > 0 then
            StkAttributeTemplateEntry.SetRange(TemplateID, StkAttributeTemplateEntry.TemplateID);

        StkAttributeTemplateEntry.SetCurrentKey(AttributeValueID);
        StkAttributeTemplateEntry.SetFilter(AttributeID, '<>%1', 0);
        StkAttributeTemplateEntry.SetFilter(AttributeValueID, '<>%1', 0);

        if not StkAttributeTemplateEntry.FindSet() then
            exit(0);

        Found := true;
        StkAttributeTemplateTree.TemplateSetId := 0;
        repeat
            StkAttributeTemplateEntry.TestField(AttributeValueID);
            if Found then
                if not StkAttributeTemplateTree.Get(StkAttributeTemplateTree.TemplateSetId, StkAttributeTemplateEntry.AttributeID, StkAttributeTemplateEntry.AttributeValueID) then begin
                    Found := false;
                    StkAttributeTemplateTree.LockTable();
                end;

            if not Found then begin
                StkAttributeTemplateTree.ParentTemplateSetId := StkAttributeTemplateTree.TemplateSetId;
                StkAttributeTemplateTree.TemplateAttributeId := StkAttributeTemplateEntry.AttributeID;
                StkAttributeTemplateTree.TemplateValueId := StkAttributeTemplateEntry.AttributeValueID;
                StkAttributeTemplateTree.TemplateSetId := 0;
                StkAttributeTemplateTree.InUse := false;
                if not StkAttributeTemplateTree.Insert(true) then
                    StkAttributeTemplateTree.Get(StkAttributeTemplateTree.ParentTemplateSetId, StkAttributeTemplateTree.TemplateAttributeId, StkAttributeTemplateTree.TemplateValueId);
            end;
        until StkAttributeTemplateEntry.Next() = 0;

        if not StkAttributeTemplateTree.InUse then begin
            if Found then begin
                StkAttributeTemplateTree.LockTable();
                StkAttributeTemplateTree.Get(StkAttributeTemplateTree.ParentTemplateSetId, StkAttributeTemplateTree.TemplateAttributeId, StkAttributeTemplateTree.TemplateValueId);
            end;
            StkAttributeTemplateTree.InUse := true;
            StkAttributeTemplateTree.Modify();

            InsertTemplateSetEntries(StkAttributeTemplateEntry, StkAttributeTemplateTree.TemplateSetId);
        end;

        StkAttributeTemplateEntry.Copy(StkAttributeTemplateEntry2);

        exit(StkAttributeTemplateTree.TemplateSetId);
    end;

    /// <summary>
    /// InsertTemplateSetEntries.
    /// </summary>
    /// <param name="StockedAttrTemplateSet">VAR Record PTEStkAttributeTemplateEntry.</param>
    /// <param name="NewId">Integer.</param>
    local procedure InsertTemplateSetEntries(var StockedAttrTemplateSet: Record PTEStkAttributeTemplateEntry; NewId: Integer)
    var
        StockedAttrTemplateSet2: Record PTEStkAttributeTemplateEntry;
    begin
        StockedAttrTemplateSet2.LockTable();
        if StockedAttrTemplateSet.FindSet() then
            repeat
                StockedAttrTemplateSet2 := StockedAttrTemplateSet;
                StockedAttrTemplateSet2.TemplateID := NewID;
                StockedAttrTemplateSet2.Insert();
            until StockedAttrTemplateSet.Next() = 0;
    end;
}