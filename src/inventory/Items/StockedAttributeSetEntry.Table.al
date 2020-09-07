table 50102 StockedAttributeSetEntry
{
    Caption = 'Stocked Attribute Set Entry';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; AttributeSetID; Integer)
        {
            Caption = 'Attribute Set ID';
            DataClassification = SystemMetadata;
        }
        field(2; AttributeID; Integer)
        {
            Caption = 'Attribute ID';
            DataClassification = SystemMetadata;
            TableRelation = "Item Attribute".ID where(StockedAttribute = Const(true));
        }

        field(3; AttributeValueID; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = SystemMetadata;
            TableRelation = "Item Attribute Value".ID where("Attribute ID" = Field(AttributeID));
        }
        field(4; "Attribute Code"; Text[250])
        {
            Caption = 'Attribute';
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Attribute".Name where(ID = field(AttributeID)));
            Editable = false;
        }
        field(5; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Attribute Value".Value where(ID = field(AttributeValueID), "Attribute ID" = field(AttributeID)));
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

    procedure GetAttributeSetID(var StockedAttributeSetEntry: Record StockedAttributeSetEntry): Integer;
    var
        StockedAttributeTreeNode: Record StockedAttributeTreeNode;
        StockedAttributeSetEntry2: Record StockedAttributeSetEntry;
        Found: Boolean;
    begin
        StockedAttributeSetEntry2.COPY(StockedAttributeSetEntry);
        if StockedAttributeSetEntry.AttributeSetID > 0 then
            StockedAttributeSetEntry.SETRANGE(AttributeSetID, StockedAttributeSetEntry.AttributeSetID);

        StockedAttributeSetEntry.SETCURRENTKEY(AttributeValueID);
        StockedAttributeSetEntry.SETFILTER(AttributeID, '<>%1', 0);
        StockedAttributeSetEntry.SETFILTER(AttributeValueID, '<>%1', 0);
        if not StockedAttributeSetEntry.FindSet() then
            exit(0);

        Found := true;
        StockedAttributeTreeNode."Attribute Set ID" := 0;
        repeat
            StockedAttributeSetEntry.TestField(AttributeValueID);
            if Found then
                if not StockedAttributeTreeNode.Get(StockedAttributeTreeNode."Attribute Set ID", StockedAttributeSetEntry.AttributeValueID) then begin
                    Found := false;
                    StockedAttributeTreeNode.LockTable();
                end;

            if not Found then begin
                StockedAttributeTreeNode."Parent Attribute Set ID" := StockedAttributeTreeNode."Attribute Set ID";
                StockedAttributeTreeNode."Attribute Value ID" := StockedAttributeSetEntry.AttributeValueID;
                StockedAttributeTreeNode."Attribute Set ID" := 0;
                StockedAttributeTreeNode."In Use" := false;
                if not StockedAttributeTreeNode.Insert(true) then
                    StockedAttributeTreeNode.Get(StockedAttributeTreeNode."Parent Attribute Set ID", StockedAttributeTreeNode."Attribute Value ID");
            end;
        until StockedAttributeSetEntry.Next() = 0;

        if not StockedAttributeTreeNode."In Use" then begin
            if Found then begin
                StockedAttributeTreeNode.LockTable();
                StockedAttributeTreeNode.Get(StockedAttributeTreeNode."Parent Attribute Set ID", StockedAttributeTreeNode."Attribute Value ID");
            end;
            StockedAttributeTreeNode."In Use" := true;
            StockedAttributeTreeNode.Modify(true);

            InsertAttributeSetEntries(StockedAttributeSetEntry, StockedAttributeTreeNode."Attribute Set ID");
        end;

        StockedAttributeSetEntry.COPY(StockedAttributeSetEntry2);

        exit(StockedAttributeTreeNode."Attribute Set ID");
    end;

    local procedure InsertAttributeSetEntries(var StockedAttributeSetEntry: Record StockedAttributeSetEntry; NewId: Integer)
    var
        StockedAttributeSetEntry2: Record StockedAttributeSetEntry;
    begin
        StockedAttributeSetEntry2.LockTable();
        if StockedAttributeSetEntry.FindSet() then
            repeat
                StockedAttributeSetEntry2 := StockedAttributeSetEntry;
                StockedAttributeSetEntry2.AttributeSetID := NewID;
                StockedAttributeSetEntry2.Insert();
            until StockedAttributeSetEntry.Next() = 0;
    end;
}

