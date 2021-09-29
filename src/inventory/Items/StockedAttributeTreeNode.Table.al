/// <summary>
/// Table StockedAttributeTreeNode (ID 50101).
/// </summary>
table 50101 StockedAttributeTreeNode
{
    Caption = 'Stocked Attribute Tree Node';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Parent Attribute Set ID"; Integer)
        {
            Caption = 'Attribute Set ID';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Attribute Value ID"; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = CustomerContent;
        }
        field(3; "Attribute Set ID"; Integer)
        {
            Caption = 'Attribute Set ID';
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "In Use"; Boolean)
        {
            caption = 'In Use';
            DataClassification = CustomerContent;
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

