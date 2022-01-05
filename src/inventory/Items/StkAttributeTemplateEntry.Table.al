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

        field(3; "Attribute Code"; Text[250])
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
        StkAttributeTemplateTree."Template Set ID" := 0;
        repeat
            StkAttributeTemplateEntry.TestField(AttributeValueID);
            if Found then
                if StkAttributeTemplateTree.Get(StkAttributeTemplateTree."Template Set ID", StkAttributeTemplateEntry.AttributeID, StkAttributeTemplateEntry.AttributeValueID) then begin
                    Found := false;
                    StkAttributeTemplateTree.LockTable();
                end;

            if not Found then begin
                StkAttributeTemplateTree."Parent Template Set ID" := StkAttributeTemplateTree."Template Set ID";
                StkAttributeTemplateTree."Template Attribute ID" := StkAttributeTemplateEntry.AttributeID;
                StkAttributeTemplateTree."Template Value ID" := StkAttributeTemplateEntry.AttributeValueID;
                StkAttributeTemplateTree."Template Set ID" := 0;
                StkAttributeTemplateTree."In Use" := false;
                if not StkAttributeTemplateTree.Insert(true) then
                    StkAttributeTemplateTree.Get(StkAttributeTemplateTree."Parent Template Set ID", StkAttributeTemplateTree."Template Attribute ID", StkAttributeTemplateTree."Template Value ID");
            end;
        until StkAttributeTemplateEntry.Next() = 0;

        if not StkAttributeTemplateTree."In Use" then begin
            if Found then begin
                StkAttributeTemplateTree.LockTable();
                StkAttributeTemplateTree.Get(StkAttributeTemplateTree."Parent Template Set ID", StkAttributeTemplateTree."Template Attribute ID", StkAttributeTemplateTree."Template Value ID");
            end;
            StkAttributeTemplateTree."In Use" := true;
            StkAttributeTemplateTree.Modify();

            InsertTemplateSetEntries(StkAttributeTemplateEntry, StkAttributeTemplateTree."Template Set ID");
        end;

        StkAttributeTemplateEntry.Copy(StkAttributeTemplateEntry2);

        exit(StkAttributeTemplateTree."Template Set ID");
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