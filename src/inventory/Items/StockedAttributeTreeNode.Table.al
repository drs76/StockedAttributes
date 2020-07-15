table 50101 StockedAttributeTreeNode
{
    Caption = 'Stocked Attribute Tree Node';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Parent Attribute Set ID"; Integer)
        {
            Caption = 'Attribute Set ID';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Attribute Value ID"; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = SystemMetadata;
        }
        field(3; "Attribute Set ID"; Integer)
        {
            Caption = 'Attribute Set ID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "In Use"; Boolean)
        {
            caption = 'In Use';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Parent Attribute Set ID", "Attribute Value ID")
        {
            Clustered = true;
        }
    }
}

