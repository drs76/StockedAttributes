/// <summary>
/// TablePTEStkAttributeSetEntry (ID 50102).
/// </summary>
table 50102 PTEStkAttributeSetEntry
{
    Caption = 'Stocked Attribute Set Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; AttributeSetID; Integer)
        {
            Caption = 'Attribute Set ID';
            DataClassification = CustomerContent;
        }
        field(2; AttributeID; Integer)
        {
            Caption = 'Attribute ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute".ID where(PTEStkAttribute = Const(true));
        }

        field(3; AttributeValueID; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = CustomerContent;
            TableRelation = "Item Attribute Value".ID where("Attribute ID" = Field(AttributeID));
        }
        field(4; "Attribute Code"; Text[250])
        {
            Caption = 'Attribute';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute".Name where(ID = field(AttributeID)));
            Editable = false;
        }
        field(5; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute Value".Value where(ID = field(AttributeValueID), "Attribute ID" = field(AttributeID)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; AttributeSetID, AttributeID)
        {
            Clustered = true;
        }
        key(key2; AttributeValueID) { }
        key(Key3; AttributeID, AttributeValueID, AttributeSetID) { }
    }

    /// <summary>
    /// GetAttributeSetID.
    /// </summary>
    /// <param name="StkAttributeSetEntry">VAR Record PTEStkAttributeSetEntry.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetAttributeSetID(var StkAttributeSetEntry: Record PTEStkAttributeSetEntry): Integer;
    var
        StkAttributeTreeNode: Record PTEStkAttributeTreeNode;
        StkAttributeSetEntry2: Record PTEStkAttributeSetEntry;
        Found: Boolean;
    begin
        StkAttributeSetEntry2.Copy(StkAttributeSetEntry);
        if StkAttributeSetEntry.AttributeSetID > 0 then
            StkAttributeSetEntry.SetRange(AttributeSetID, StkAttributeSetEntry.AttributeSetID);

        StkAttributeSetEntry.SetCurrentKey(AttributeValueID);
        StkAttributeSetEntry.SetFilter(AttributeID, '<>%1', 0);
        StkAttributeSetEntry.SetFilter(AttributeValueID, '<>%1', 0);
        if not StkAttributeSetEntry.FindSet() then
            exit(0);

        Found := true;
        StkAttributeTreeNode.StkAttributeSetId := 0;
        repeat
            StkAttributeSetEntry.TestField(AttributeValueID);
            if Found then
                if not StkAttributeTreeNode.Get(StkAttributeTreeNode.StkAttributeSetId, StkAttributeSetEntry.AttributeValueID) then begin
                    Found := false;
                    StkAttributeTreeNode.LockTable();
                end;

            if not Found then begin
                StkAttributeTreeNode."Parent Attribute Set ID" := StkAttributeTreeNode.StkAttributeSetId;
                StkAttributeTreeNode."Attribute Value ID" := StkAttributeSetEntry.AttributeValueID;
                StkAttributeTreeNode.StkAttributeSetId := 0;
                StkAttributeTreeNode."In Use" := false;
                if StkAttributeTreeNode.Insert(true) then
                    StkAttributeTreeNode.Get(StkAttributeTreeNode."Parent Attribute Set ID", StkAttributeTreeNode."Attribute Value ID");
            end;
        until StkAttributeSetEntry.Next() = 0;

        if not StkAttributeTreeNode."In Use" then begin
            if Found then begin
                StkAttributeTreeNode.LockTable();
                StkAttributeTreeNode.Get(StkAttributeTreeNode."Parent Attribute Set ID", StkAttributeTreeNode."Attribute Value ID");
            end;
            StkAttributeTreeNode."In Use" := true;
            StkAttributeTreeNode.Modify(true);

            InsertAttributeSetEntries(StkAttributeSetEntry, StkAttributeTreeNode.StkAttributeSetId);
        end;

        StkAttributeSetEntry.Copy(StkAttributeSetEntry2);

        exit(StkAttributeTreeNode.StkAttributeSetId);
    end;

    /// <summary>
    /// InsertAttributeSetEntries.
    /// </summary>
    /// <param name="StkAttributeSetEntry">VAR Record PTEStkAttributeSetEntry.</param>
    /// <param name="NewId">Integer.</param>
    local procedure InsertAttributeSetEntries(var StkAttributeSetEntry: Record PTEStkAttributeSetEntry; NewId: Integer)
    var
        StkAttributeSetEntry2: Record PTEStkAttributeSetEntry;
    begin
        StkAttributeSetEntry2.LockTable();
        if StkAttributeSetEntry.FindSet() then
            repeat
                StkAttributeSetEntry2 := StkAttributeSetEntry;
                StkAttributeSetEntry2.AttributeSetID := NewID;
                StkAttributeSetEntry2.Insert();
            until StkAttributeSetEntry.Next() = 0;
    end;
}

