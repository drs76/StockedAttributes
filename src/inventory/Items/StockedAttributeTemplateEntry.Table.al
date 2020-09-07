table 50104 StockedAttributeTemplateEntry
{
    Caption = 'Stocked Attribute Template Entry';

    fields
    {
        field(1; TemplateID; Integer)
        {
            Caption = 'Template ID';
            DataClassification = SystemMetadata;
        }
        field(2; AttributeID; Integer)
        {
            Caption = 'Attribute ID';
            DataClassification = SystemMetadata;
            TableRelation = "Item Attribute".ID where(StockedAttribute = const(true));
        }

        field(3; "Attribute Code"; Text[250])
        {
            Caption = 'Attribute';
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Attribute".Name where(ID = field(AttributeID)));
            Editable = false;
        }
        field(4; AttributeValueID; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = SystemMetadata;
            TableRelation = "Item Attribute Value".ID where("Attribute ID" = Field(AttributeID));
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
        key(PK; TemplateID, AttributeID, AttributeValueID)
        {
            Clustered = true;
        }
        key(key2; AttributeValueID) { }
        key(Key3; AttributeID, AttributeValueID, TemplateID) { }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Attribute Code", "Attribute Value")
        {

        }
        fieldgroup(Brick; "Attribute Code", "Attribute Value")
        {

        }
    }

    procedure GetTemplateSetID(var StockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry): Integer;
    var
        StockedAttributeTemplateTree: Record StockedAttributeTemplateTree;
        StockedAttributeTemplateEntry2: Record StockedAttributeTemplateEntry;
        Found: Boolean;
    begin
        StockedAttributeTemplateEntry2.Copy(StockedAttributeTemplateEntry);
        if StockedAttributeTemplateEntry.TemplateID > 0 then
            StockedAttributeTemplateEntry.SetRange(TemplateID, StockedAttributeTemplateEntry.TemplateID);

        StockedAttributeTemplateEntry.SetCurrentKey(AttributeValueID);
        StockedAttributeTemplateEntry.SetFilter(AttributeID, '<>%1', 0);
        StockedAttributeTemplateEntry.SetFilter(AttributeValueID, '<>%1', 0);

        if not StockedAttributeTemplateEntry.FindSet() then
            exit(0);

        Found := true;
        StockedAttributeTemplateTree."Template Set ID" := 0;
        repeat
            StockedAttributeTemplateEntry.TestField(AttributeValueID);
            if Found then
                if not StockedAttributeTemplateTree.Get(StockedAttributeTemplateTree."Template Set ID", StockedAttributeTemplateEntry.AttributeID, StockedAttributeTemplateEntry.AttributeValueID) then begin
                    Found := false;
                    StockedAttributeTemplateTree.LockTable();
                end;
            if not Found then begin
                StockedAttributeTemplateTree."Parent Template Set ID" := StockedAttributeTemplateTree."Parent Template Set ID";
                StockedAttributeTemplateTree."Template Attribute ID" := StockedAttributeTemplateEntry.AttributeID;
                StockedAttributeTemplateTree."Template Value ID" := StockedAttributeTemplateEntry.AttributeValueID;
                StockedAttributeTemplateTree."Template Set ID" := 0;
                StockedAttributeTemplateTree."In Use" := false;
                if not StockedAttributeTemplateTree.Insert(true) then
                    StockedAttributeTemplateTree.Get(StockedAttributeTemplateTree."Parent Template Set ID", StockedAttributeTemplateTree."Template Attribute ID", StockedAttributeTemplateTree."Template Value ID");
            end;
        until StockedAttributeTemplateEntry.Next() = 0;
        if not StockedAttributeTemplateTree."In Use" then begin
            if Found then begin
                StockedAttributeTemplateTree.LockTable();
                StockedAttributeTemplateTree.Get(StockedAttributeTemplateTree."Parent Template Set ID", StockedAttributeTemplateTree."Template Attribute ID", StockedAttributeTemplateTree."Template Value ID");
            end;
            StockedAttributeTemplateTree."In Use" := true;
            StockedAttributeTemplateTree.Modify();

            InsertTemplateSetEntries(StockedAttributeTemplateEntry, StockedAttributeTemplateTree."Template Set ID");
        end;

        StockedAttributeTemplateEntry.Copy(StockedAttributeTemplateEntry2);

        exit(StockedAttributeTemplateTree."Template Set ID");
    end;

    local procedure InsertTemplateSetEntries(var StockedAttrTemplateSet: Record StockedAttributeTemplateEntry; NewId: Integer)
    var
        StockedAttrTemplateSet2: Record StockedAttributeTemplateEntry;
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